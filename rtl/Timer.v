`include "global.v"
module Timer(
    input wire clk,
    input wire rest,
    // Bus Interface
    input  wire Timer_cs,                  // 片选
    input  wire Timer_as,                  // 选通
    input  wire Timer_rw,                  // 读写
    output wire Timer_rdy,                 // 就绪
    input wire[3:0] Timer_addr,            // 地址
    input wire[`WORD_DATA] Timer_wr_data,  // 写数据
    output reg[`WORD_DATA] Timer_rd_data   // 读数据
    output reg Timer_irq;                  // 中断
);
    // 暂时只支持向上计数
    wire expr_flag = (counter == expr_val) && (start == `ENABLE) ? `ENABLE : `DISABLE;

    // 模式选择
    // 高位决定向上/向下计数，低位决定单次/循环计数
    reg[1:0] mode;
    reg start; // 开始位
    reg over;
    // `WORD_DATA决定了最大的计数值
    reg[`WORD_DATA] expr_val; // 最大值
    reg[`WORD_DATA] counter; // 计数器


    always @(posedge clk) begin
        Timer_irq <= expr_flag; // 计数器满则发起中断

        if (rest == `RESET) begin
            mode <= `TIMER_SINGLE_UP;
            start <= `TIMER_DISABLE;
            expr_val <= `TIMER_MAX_EXPR;
        end else begin
            // 就绪
            if ((Timer_cs == `ENABLE) && (Timer_as == `ENABLE)) begin
                Timer_rdy <= `ENABLE;
            end else begin
                Timer_rdy <= `DISABLE;
            end

            // 读出控制
            if ((Timer_cs == `ENABLE) && (Timer_as == `ENABLE) && (Timer_rw == `READ)) begin               
                case (Timer_addr)
                    `TIME_EXPR_ADDR:begin
                        Timer_rd_data <= expr_val;
                    end
                    `TIME_COUNTER_ADDR:begin
                        Timer_rd_data <= counter;
                    end
                    `TIME_STATE_ADDR:begin
                        Timer_rd_data <= {{29{1'b0}}, mode, start};
                    end
                endcase
            end
            // 写入控制
            if ((Timer_cs == `ENABLE) && (Timer_as == `ENABLE) && (Timer_rw == `WRITE) && (addr == `TIMER_CTRL_ADDR)) begin
                mode <= Timer_wr_data[1:0];
                start <= Timer_wr_data[2];
            end

            // 更新计数器
            if (expr_flag == `ENABLE)begin
                case(mode)
                    `TIMER_SINGLE_UP:begin
                        start <= `DISABLE;
                    end
                    `TIMER_CIRCLE_UP:begin
                        counter <= 32'b0;
                    end
                endcase
            end else if (start == `TIMER_ENABLE)begin
                counter <= counter + 32'b1;
            end else begin // start位置停止的计数器清零
                counter <= 32'b0;
            end
        end
        
    end

endmodule
`include "global.v"

module regs(
    input wire clk,
    input wire rest,
    // from ID
    input wire[`REGS_ADDR] id2regs_rs1_addr_i,
    input wire[`REGS_ADDR] id2regs_rs2_addr_i,
    // to ID
    output reg[`WORD_DATA] regs2id_rs1_data_o,
    output reg[`WORD_DATA] regs2id_rs2_data_o,
    // from EX
    input wire[`REGS_ADDR] ex2regs_rd_addr_i,
    input wire[`WORD_DATA] ex2regs_rd_data_i,
    input wire ex2regs_wb_en_i,
    // input wire ex2regs_mem_rd_i, // 防止译码冲突
    // from mem
    input wire mem2regs_wb_en_i,
    input wire[`RISCV_RD] mem2regs_rd_i,
    input wire[`WORD_DATA] mem2regs_rd_data_i
    // input wire[`WORD_DATA] mem2regs_passbynetwork_i   // 数据旁路 
);
    // 寄存器堆
    reg[`WORD_DATA] x_regs[0:31];
    integer i;

    // 这里还有一次控制冒险没有判断
    // ID
    // rs1
    always @(*) begin
        if (rest == `RESET) begin
            regs2id_rs1_data_o = `DEFAULT_32_ZERO;
        end else if (id2regs_rs1_addr_i == ex2regs_rd_addr_i) begin // 防止写回和译码冲突（后期专门用一个模块来处理）
            regs2id_rs1_data_o = ex2regs_rd_data_i;
        end else if (id2regs_rs1_addr_i == mem2regs_rd_i) begin
            regs2id_rs1_data_o = mem2regs_rd_data_i;
        end else begin
            regs2id_rs1_data_o = x_regs[id2regs_rs1_addr_i];
        end

        // else if (ex2regs_mem_rd_i == `ENABLE && id2regs_rs1_addr_i == ex2regs_rd_addr_i) begin
        //     regs2id_rs1_data_o = mem2regs_passbynetwork_i;
        // end 
    end

    // rs2
    always @(*) begin
        if (rest == `RESET) begin
            regs2id_rs2_data_o = `DEFAULT_32_ZERO;
        end else if (id2regs_rs2_addr_i == ex2regs_rd_addr_i) begin // 防止写回和译码冲突（后期专门用一个模块来处理）
            regs2id_rs2_data_o = ex2regs_rd_data_i;
        end else if (id2regs_rs2_addr_i == mem2regs_rd_i) begin
            regs2id_rs2_data_o = mem2regs_rd_data_i;
        end else begin
            regs2id_rs2_data_o = x_regs[id2regs_rs2_addr_i];
        end

        // else if (ex2regs_mem_rd_i == `ENABLE && id2regs_rs2_addr_i == ex2regs_rd_addr_i) begin
        //     regs2id_rs2_data_o = mem2regs_passbynetwork_i;
        // end
    end

    //EX
    always @(posedge clk) begin
        if (rest == `RESET) begin
            for (i = 0;i < `REGS_NUM; i = i + 1) begin
                x_regs[i] <= `DEFAULT_32_ZERO;
            end
        end else begin
            if (ex2regs_wb_en_i == `ENABLE) begin
                x_regs[ex2regs_rd_addr_i] <= ex2regs_rd_data_i;
            end
            if (mem2regs_wb_en_i == `ENABLE) begin
                x_regs[mem2regs_rd_i] <= mem2regs_rd_data_i;
            end
        end
        // x0必定为0
        x_regs[5'b0] <= `DEFAULT_32_ZERO;
    end

endmodule
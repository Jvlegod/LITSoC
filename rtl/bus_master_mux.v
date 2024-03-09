`include "global.v"

module bus_master_mux(
    input wire[`BUS_SLAVE_ADDR] m0_addr,      // 地址
    input wire m0_as,                         // 选通
    input wire m0_rw,                         // 读写
    input wire[`WORD_DATA] m0_wr_data,        // 写入
    input wire m0_grnt,                       // 赋予

    input wire[`BUS_SLAVE_ADDR] m1_addr,     
    input wire m1_as,       
    input wire m1_rw,       
    input wire[`WORD_DATA] m1_wr_data,  
    input wire m1_grnt,     

    input wire[`BUS_SLAVE_ADDR] m2_addr,     
    input wire m2_as,       
    input wire m2_rw,       
    input wire[`WORD_DATA] m2_wr_data,  
    input wire m2_grnt,     

    input wire[`BUS_SLAVE_ADDR] m3_addr,     
    input wire m3_as,       
    input wire m3_rw,       
    input wire[`WORD_DATA] m3_wr_data,  
    input wire m3_grnt,     

    output reg[`BUS_SLAVE_ADDR] s_addr,
    output reg s_as,
    output reg s_rw,
    output reg[`WORD_DATA] s_wr_data
);


    always @(*) begin
        if (m0_grnt == `ENABLE) begin
            s_addr = m0_addr;
            s_as = m0_as;
            s_rw = m0_rw;
            s_wr_data = m0_wr_data;
        end else if (m1_grnt == `ENABLE) begin
            s_addr = m1_addr;
            s_as = m1_as;
            s_rw = m1_rw;
            s_wr_data = m1_wr_data;
        end else if (m2_grnt == `ENABLE) begin
            s_addr = m2_addr;
            s_as = m2_as;
            s_rw = m2_rw;
            s_wr_data = m2_wr_data;
        end else if (m3_grnt == `ENABLE) begin
            s_addr = m3_addr;
            s_as = m3_as;
            s_rw = m3_rw;
            s_wr_data = m3_wr_data;
        end else begin
            s_addr = 2'b0;
            s_as = `DISABLE;
            s_rw = `READ;
            s_wr_data = `DEFAULT_32_ZERO;
        end
    end

endmodule
`include "global.v"

module bus_slave_mux(
    input wire s0_cs,                      // 片选
    input wire[`WORD_DATA] s0_rd_data,     // 读出的数据
    input wire s0_rdy,                     // 就绪

    input wire s1_cs,          
    input wire[`WORD_DATA] s1_rd_data,     
    input wire s1_rdy,         

    input wire s2_cs,          
    input wire[`WORD_DATA] s2_rd_data,     
    input wire s2_rdy,         

    input wire s3_cs,          
    input wire[`WORD_DATA] s3_rd_data,     
    input wire s3_rdy,         

    input wire s4_cs,          
    input wire[`WORD_DATA] s4_rd_data,     
    input wire s4_rdy,         

    input wire s5_cs,          
    input wire[`WORD_DATA] s5_rd_data,     
    input wire s5_rdy,         

    input wire s6_cs,          
    input wire[`WORD_DATA] s6_rd_data,     
    input wire s6_rdy,         

    input wire s7_cs,          
    input wire[`WORD_DATA] s7_rd_data,     
    input wire s7_rdy,      

    output reg[`WORD_DATA] bus_rd_data;    // 读出的数据
    output reg bus_rdy;
);

    always @(*) begin
        if (s0_cs == `ENABLE) begin
            bus_rd_data = s0_rd_data;
            bus_rdy = s0_rdy;
        end else if (s1_cs == `ENABLE) begin
            bus_rd_data = s1_rd_data;
            bus_rdy = s1_rdy;
        end else if (s2_cs == `ENABLE) begin
            bus_rd_data = s2_rd_data;
            bus_rdy = s2_rdy;
        end else if (s3_cs == `ENABLE) begin
            bus_rd_data = s3_rd_data;
            bus_rdy = s3_rdy;
        end else if (s4_cs == `ENABLE) begin
            bus_rd_data = s4_rd_data;
            bus_rdy = s4_rdy;
        end else if (s5_cs == `ENABLE) begin
            bus_rd_data = s5_rd_data;
            bus_rdy = s5_rdy;
        end else if (s6_cs == `ENABLE) begin
            bus_rd_data = s6_rd_data;
            bus_rdy = s6_rdy;
        end else if (s7_cs == `ENABLE) begin
            bus_rd_data = s7_rd_data;
            bus_rdy = s7_rdy;
        end else begin
            bus_rd_data = `DEFAULT_32_ZERO;
            bus_rdy = `DISABLE;
        end
    end

endmodule
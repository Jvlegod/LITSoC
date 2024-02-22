`include "global.v"

module CU(
    input clk,
    input rest,

    // from EXU
    input wire ex2cu_jump_en_i,
    // to IFID and IDEX
    output reg cu2_refresh_flag_o, // 刷新流水线
    // to PC
    output reg cu2pc_jump_en_o, // jump使能
    // from ID
    input wire id2cu_wb_en_i, // 写回使能
    // to EX
    output reg cu2ex_wb_en_o // 写回使能
);

    always @(*) begin
        if (ex2cu_jump_en_i == `ENABLE) begin
            cu2_refresh_flag_o = `ENABLE;
        end else begin
            cu2_refresh_flag_o = `DISABLE;
        end
    end

    always @(*) begin
        if (ex2cu_jump_en_i == `ENABLE) begin
            cu2pc_jump_en_o = `ENABLE;
        end else begin
            cu2pc_jump_en_o = `DISABLE;
        end
    end

    // 停止一拍，方便和EX同步
    always @(posedge clk) begin
        if (rest == `RESET) begin
            cu2ex_wb_en_o <= `DISABLE;
        end else begin
            cu2ex_wb_en_o <= id2cu_wb_en_i;
        end
    end

endmodule
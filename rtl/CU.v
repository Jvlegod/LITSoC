`include "global.v"

module CU(
    // from EXU
    input wire ex2cu_jump_en_i,
    // to IFID and IDEX
    output reg cu2_refresh_flag_o, // 刷新流水线
    // to PC
    output reg cu2pc_jump_en_o
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

endmodule
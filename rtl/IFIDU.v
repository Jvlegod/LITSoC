`include "global.v"

module IFIDU(
    input wire clk,
    input wire rest,
    // from IF
    input wire[`WORD_ADDR] if2ifid_addr_i,
    input wire[`WORD_ADDR] if2ifid_ins_i,
    // to ID
    output wire[`WORD_ADDR] ifid2id_ins_o,
    output wire[`WORD_ADDR] ifid2id_addr_o,
    // from CU
    input wire cu2_refresh_flag_i
);
    wire refresh_flag;

    assign refresh_flag = (cu2_refresh_flag_i == `ENABLE) ? `ENABLE : `DISABLE;

    DFF #(32) inst_1 (clk, rest, `DEFAULT_32_ZERO, if2ifid_addr_i, ifid2id_addr_o, refresh_flag);
    DFF #(32) inst_2 (clk, rest, `DEFAULT_32_ZERO, if2ifid_ins_i, ifid2id_ins_o, refresh_flag);

    // DFF #(32) inst_1 (clk, rest, `DEFAULT_32_ZERO, if2ifid_addr_i, ifid2id_addr_o, `ENABLE);
    // DFF #(32) inst_2 (clk, rest, `DEFAULT_32_ZERO, if2ifid_ins_i, ifid2id_ins_o, `ENABLE);

endmodule
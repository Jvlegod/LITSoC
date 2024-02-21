`include "global.v"

module IDEXU(
    input wire clk,
    input wire rest,
    // from ID
    input wire[`WORD_ADDR] id2idex_source1_i,
    input wire[`WORD_ADDR] id2idex_source2_i,
    input wire[`WORD_ADDR] id2idex_ins_i,
    input wire[`WORD_ADDR] id2idex_addr_i,
    input wire[`REGS_ADDR] id2idex_rd_addr_i,

    input wire[`RISCV_OPCODE] id2idex_opcode_i,
    input wire[`RISCV_RD] id2idex_rd_i,
    input wire[`RISCV_RS1] id2idex_rs1_i,
    input wire[`RISCV_RS2] id2idex_rs2_i,
    input wire[`RISCV_FUNCT3] id2idex_funct3_i,
    //I
    input wire[`WORD_DATA] id2idex_imm_i_i,
    //SB
    output wire[`WORD_DATA] id2idex_imm_sb_i,
    //UJ
    output wire[`WORD_DATA] id2idex_imm_uj_i,
    // to EX
    output wire[`WORD_ADDR] idex2ex_source1_o,
    output wire[`WORD_ADDR] idex2ex_source2_o,
    output wire[`WORD_ADDR] idex2ex_id_ins_o, // 可能不需要用
    output wire[`WORD_ADDR] idex2ex_addr_o,
    output wire[`REGS_ADDR] idex2ex_rd_addr_o,

    output wire[`RISCV_OPCODE] idex2ex_opcode_o,
    output wire[`RISCV_RD] idex2ex_rd_o,
    output wire[`RISCV_RS1] idex2ex_rs1_o,
    output wire[`RISCV_RS2] idex2ex_rs2_o,
    output wire[`RISCV_FUNCT3] idex2ex_funct3_o,
    //I
    output wire[`WORD_DATA] idex2ex_imm_i_o,
    //SB
    output wire[`WORD_DATA] idex2ex_imm_sb_o,
    //UJ
    output wire[`WORD_DATA] idex2ex_imm_uj_o,
    // from CU
    input wire cu2_refresh_flag_i
);
    wire refresh_flag;

    assign refresh_flag = (cu2_refresh_flag_i == `ENABLE) ? `ENABLE : `DISABLE;

    DFF #(32) u_DFF_1 (clk, rest, `DEFAULT_32_ZERO, id2idex_source1_i, idex2ex_source1_o, refresh_flag);
    DFF #(32) u_DFF_2 (clk, rest, `DEFAULT_32_ZERO, id2idex_source2_i, idex2ex_source2_o, refresh_flag);
    DFF #(32) u_DFF_3 (clk, rest, `DEFAULT_32_ZERO, id2idex_ins_i, idex2ex_id_ins_o, refresh_flag);
    DFF #(32) u_DFF_4 (clk, rest, `DEFAULT_32_ZERO, id2idex_addr_i, idex2ex_addr_o, refresh_flag);
    DFF #(5 ) u_DFF_5 (clk, rest, `DEFAULT_5_ZERO, id2idex_rd_addr_i, idex2ex_rd_addr_o, refresh_flag);
    
    DFF #(7 ) u_DFF_6  (clk, rest, 7'b0, id2idex_opcode_i, idex2ex_opcode_o, refresh_flag);
    DFF #(5 ) u_DFF_7  (clk, rest, 5'b0, id2idex_rd_i, idex2ex_rd_o, refresh_flag);
    DFF #(5 ) u_DFF_8  (clk, rest, 5'b0, id2idex_rs1_i, idex2ex_rs1_o, refresh_flag);
    DFF #(5 ) u_DFF_9  (clk, rest, 5'b0, id2idex_rs2_i, idex2ex_rs2_o, refresh_flag);
    DFF #(3 ) u_DFF_10 (clk, rest, 3'b0, id2idex_funct3_i, idex2ex_funct3_o, refresh_flag);
    //I
    DFF #(32) u_DFF_11 (clk, rest, `DEFAULT_32_ZERO, id2idex_imm_i_i, idex2ex_imm_i_o, refresh_flag);
    //SB
    DFF #(32) u_DFF_12 (clk, rest, `DEFAULT_32_ZERO, id2idex_imm_sb_i, idex2ex_imm_sb_o, refresh_flag);
    //UJ
    DFF #(32) u_DFF_13 (clk, rest, `DEFAULT_32_ZERO, id2idex_imm_uj_i, idex2ex_imm_uj_o, refresh_flag);
    
    // DFF #(32) u_DFF_1 (clk, rest, `DEFAULT_32_ZERO, id2idex_source1_i, idex2ex_source1_o, `ENABLE);
    // DFF #(32) u_DFF_2 (clk, rest, `DEFAULT_32_ZERO, id2idex_source2_i, idex2ex_source2_o, `ENABLE);
    // DFF #(32) u_DFF_3 (clk, rest, `DEFAULT_32_ZERO, id2idex_ins_i, idex2ex_id_ins_o, `ENABLE);
    // DFF #(32) u_DFF_4 (clk, rest, `DEFAULT_32_ZERO, id2idex_addr_i, idex2ex_addr_o, `ENABLE);
    // DFF #(5 ) u_DFF_5 (clk, rest, `DEFAULT_5_ZERO, id2idex_rd_addr_i, idex2ex_rd_addr_o, `ENABLE);
    
    // DFF #(7 ) u_DFF_6  (clk, rest, 7'b0, id2idex_opcode_i, idex2ex_opcode_o, `ENABLE);
    // DFF #(5 ) u_DFF_7  (clk, rest, 5'b0, id2idex_rd_i, idex2ex_rd_o, `ENABLE);
    // DFF #(5 ) u_DFF_8  (clk, rest, 5'b0, id2idex_rs1_i, idex2ex_rs1_o, `ENABLE);
    // DFF #(5 ) u_DFF_9  (clk, rest, 5'b0, id2idex_rs2_i, idex2ex_rs2_o, `ENABLE);
    // DFF #(3 ) u_DFF_10 (clk, rest, 3'b0, id2idex_funct3_i, idex2ex_funct3_o, `ENABLE);
    // //I
    // DFF #(32) u_DFF_11 (clk, rest, `DEFAULT_32_ZERO, id2idex_imm_i_i, idex2ex_imm_i_o, `ENABLE);
    // //SB
    // DFF #(32) u_DFF_12 (clk, rest, `DEFAULT_32_ZERO, id2idex_imm_sb_i, idex2ex_imm_sb_o, `ENABLE);
    // //UJ
    // DFF #(32) u_DFF_13 (clk, rest, `DEFAULT_32_ZERO, id2idex_imm_uj_i, idex2ex_imm_uj_o, `ENABLE);
endmodule
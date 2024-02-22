`include "global.v"

module ALU(
    // src1: rs1
    // src2: rs2 imm
    input wire  [`WORD_DATA] ALU_source1,
    input wire  [`WORD_DATA] ALU_source2,
    output wire [`WORD_DATA] ALU_add,
    output wire [`WORD_DATA] ALU_sub,
    output wire [`WORD_DATA] ALU_and,
    output wire [`WORD_DATA] ALU_or,
    output wire [`WORD_DATA] ALU_xor,
    output wire [`WORD_DATA] ALU_sll,
    output wire [`WORD_DATA] ALU_srl,
    output wire [`WORD_DATA] ALU_stl,
    output wire [`WORD_DATA] ALU_stlu,
    output wire  ALU_beq,
    output wire  ALU_bne,
    output wire  ALU_blt,
    output wire  ALU_bge,
    output wire  ALU_bltu,
    output wire  ALU_bgeu
);

    assign ALU_add = ALU_source1 + ALU_source2;
    assign ALU_sub = ALU_source1 - ALU_source2;
    assign ALU_and = ALU_source1 & ALU_source2;
    assign ALU_or = ALU_source1 | ALU_source2;
    assign ALU_xor = ALU_source1 ^ ALU_source2;
    assign ALU_sll = ALU_source1 << {{6{1'b0}}, ALU_source2[5:0]}; // 此处ALU_source2[5]为0有效，逻辑没写
    assign ALU_srl = ALU_source1 >> {{6{1'b0}}, ALU_source2[5:0]}; // 此处ALU_source2[5]为0有效，逻辑没写
    assign ALU_stl = ($signed(ALU_source1)) < ($signed(ALU_source2)) ? 32'b1 : 32'b0;
    assign ALU_stlu = (ALU_source1) < (ALU_source2) ? 32'b1 : 32'b0;
    assign ALU_beq = ($signed(ALU_source1) == $signed(ALU_source2)) ? `ENABLE : `DISABLE;
    assign ALU_bne = ($signed(ALU_source1) != $signed(ALU_source2)) ? `ENABLE : `DISABLE;
    assign ALU_blt = ($signed(ALU_source1) < $signed(ALU_source2)) ? `ENABLE : `DISABLE;
    assign ALU_bge = ($signed(ALU_source1) >= $signed(ALU_source2)) ? `ENABLE : `DISABLE;
    assign ALU_bltu = (ALU_source1 < ALU_source2) ? `ENABLE : `DISABLE;
    assign ALU_bgeu = (ALU_source1 >= ALU_source2) ? `ENABLE : `DISABLE;

endmodule
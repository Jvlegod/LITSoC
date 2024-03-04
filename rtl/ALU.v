`include "global.v"

module ALU(
    // src1: rs1
    // src2: rs2 imm
    // ALU_imm_s: sign-extend
    input wire  [`WORD_DATA] ALU_source1,
    input wire  [`WORD_DATA] ALU_source2,
    input wire  [`WORD_DATA] ALU_imm_s,
    output wire [`WORD_DATA] ALU_add,
    output wire [`WORD_DATA] ALU_sub,
    output wire [`WORD_DATA] ALU_and,
    output wire [`WORD_DATA] ALU_or,
    output wire [`WORD_DATA] ALU_xor,
    output wire [`WORD_DATA] ALU_sll,
    output wire [`WORD_DATA] ALU_srl,
    output wire [`WORD_DATA] ALU_sra,
    output wire [`WORD_DATA] ALU_slt,
    output wire [`WORD_DATA] ALU_sltu,
    output wire  ALU_beq,
    output wire  ALU_bne,
    output wire  ALU_blt,
    output wire  ALU_bge,
    output wire  ALU_bltu,
    output wire  ALU_bgeu,
    output wire [`WORD_DATA] ALU_add_s_sb
);

    assign ALU_add = ALU_source1 + ALU_source2;
    assign ALU_sub = ALU_source1 - ALU_source2;
    assign ALU_and = ALU_source1 & ALU_source2;
    assign ALU_or = ALU_source1 | ALU_source2;
    assign ALU_xor = ALU_source1 ^ ALU_source2;
    assign ALU_sll = ALU_source1 << ALU_source2[4:0]; // 此处ALU_source2[5]为0有效，逻辑没写
    assign ALU_srl = ALU_source1 >> ALU_source2[4:0]; // 此处ALU_source2[5]为0有效，逻辑没写
    assign ALU_sra = ({32{ALU_source1[31]}} << (6'd32 - {1'b0, ALU_source2[4:0]})) | (ALU_source1 >> ALU_source2[4:0]); // 此处ALU_source2[5]为0有效，逻辑没写
    assign ALU_slt = ($signed(ALU_source1)) < ($signed(ALU_source2)) ? 32'b1 : 32'b0;
    assign ALU_sltu = (ALU_source1) < (ALU_source2) ? 32'b1 : 32'b0;
    assign ALU_beq = ($signed(ALU_source1) == $signed(ALU_source2)) ? `ENABLE : `DISABLE;
    assign ALU_bne = ($signed(ALU_source1) != $signed(ALU_source2)) ? `ENABLE : `DISABLE;
    assign ALU_blt = ($signed(ALU_source1) < $signed(ALU_source2)) ? `ENABLE : `DISABLE;
    assign ALU_bge = ($signed(ALU_source1) >= $signed(ALU_source2)) ? `ENABLE : `DISABLE;
    assign ALU_bltu = (ALU_source1 < ALU_source2) ? `ENABLE : `DISABLE;
    assign ALU_bgeu = (ALU_source1 >= ALU_source2) ? `ENABLE : `DISABLE;
    assign ALU_add_s_sb = ALU_imm_s + ALU_source1;// sb

endmodule
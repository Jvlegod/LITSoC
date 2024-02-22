`ifndef __DEFINE_H__
`define __DEFINE_H__

// I type INS
`define INS_TYPE_I 7'b0010011
`define INS_ADDI   3'b000
`define INS_SLTI   3'b010
`define INS_SLTIU  3'b011
`define INS_XORI   3'b100
`define INS_ORI    3'b110
`define INS_ANDI   3'b111
`define INS_SLLI   3'b001
`define INS_SRLI   3'b101

// L type INS
`define INS_TYPE_L 7'b0000011
`define INS_LB     3'b000
`define INS_LH     3'b001
`define INS_LW     3'b010
`define INS_LBU    3'b100
`define INS_LHU    3'b101

// S type INS
`define INS_TYPE_S 7'b0100011
`define INS_SB     3'b000
`define INS_SH     3'b001
`define INS_SW     3'b010

// R and M type INS
`define INS_TYPE_R_M 7'b0110011
`define INS_ADD 3'b000
// R type INS
`define INS_ADD_SUB 3'b000
`define INS_SLL    3'b001
`define INS_SLT    3'b010
`define INS_SLTU   3'b011
`define INS_XOR    3'b100
`define INS_SR     3'b101
`define INS_OR     3'b110
`define INS_AND    3'b111
// M type INS
`define INS_MUL    3'b000
`define INS_MULH   3'b001
`define INS_MULHSU 3'b010
`define INS_MULHU  3'b011
`define INS_DIV    3'b100
`define INS_DIVU   3'b101
`define INS_REM    3'b110
`define INS_REMU   3'b111

// UJ type INS
`define INS_TYPE_UJ   7'b1101111 // JAL
// `define INS_JAL    7'b1101111
`define INS_JALR   7'b1100111

`define INS_LUI    7'b0110111
`define INS_AUIPC  7'b0010111
`define INS_NOP    32'h00000013
`define INS_NOP_OP 7'b0000001
`define INS_MRET   32'h30200073
`define INS_RET    32'h00008067

`define INS_FENCE  7'b0001111
`define INS_ECALL  32'h73
`define INS_EBREAK 32'h00100073

// B type INS
`define INS_TYPE_B 7'b1100011
`define INS_BEQ    3'b000
`define INS_BNE    3'b001
`define INS_BLT    3'b100
`define INS_BGE    3'b101
`define INS_BLTU   3'b110
`define INS_BGEU   3'b111

`endif
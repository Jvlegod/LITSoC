`ifndef __GLOBAL_H__
`define __GLOBAL_H__

// 以下都为正逻辑，负逻辑在后面加_
// 正逻辑
`define RESET 1'b0
`define A_PC 32'd4
`define WORD_ADDR 31:0
`define WORD_DATA 31:0

`define ENABLE 1'b1
`define DISABLE 1'b0

`define DEFAULT_32_ZERO 32'b0
`define DEFAULT_5_ZERO 5'b0

`define RISCV_OPCODE 6:0
`define RISCV_RD 4:0
`define RISCV_RS1 4:0
`define RISCV_RS2 4:0
`define RISCV_FUNCT3 2:0

`define RISCV_IMMI 11:0
`define RISCV_IMMSB 12:0
`define RISCV_IMMUJ 20:0
// 此处改成32位，前面没考虑周到
// `define RISCV_IMMI 31:0
// `define RISCV_IMMSB 31:0
// `define RISCV_IMMUJ 31:0

`define REGS_ADDR 4:0
`define REGS_NUM 6'd32 // ?

// 负逻辑

`endif
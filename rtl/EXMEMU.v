`include "global.v"

module EXMEMU(
    input clk,
    input rest,
    // from EX
    input wire ex2exmem_wb_en_i,  // 写回使能信号
    input wire ex2exmem_mem_en_i,  // 访存使能信号
    input wire ex2exmem_mem_addr_i, // 访问的地址
    input wire[`RISCV_OPCODE] ex2exmem_opcode_i, // 操作码
    input wire[`RISCV_FUNCT3] ex2exmem_funct3_i,
    input wire[`RISCV_RD]  ex2exmem_rd_i,   // rd寄存器
    input wire[`RISCV_RS1] ex2exmem_rs1_i,  // rs1寄存器
    input wire[`RISCV_RS2] ex2exmem_rs2_i,  // rs2寄存器
    // to MEM
    output wire ex2exmem_wb_en_o,  // 写回使能信号
    output wire[`WORD_ADDR] ex2exmem_mem_addr_o,  // 访问的地址
    output wire[`RISCV_OPCODE] ex2exmem_opcode_o, // 操作码
    output wire[`RISCV_FUNCT3] ex2exmem_funct3_o,
    output wire[`RISCV_RD]  ex2exmem_rd_o,        // rd寄存器
    output wire[`RISCV_RS1] ex2exmem_rs1_o,       // rs1寄存器
    output wire[`RISCV_RS2] ex2exmem_rs2_o,       // rs2寄存器
);
    wire refresh_flag = (ex2exmem_mem_en_i == `ENABLE) ?  `ENABLE : `DISABLE; // 刷新流水线

    DFF #(1) u_DFF_1 (clk, rest, 1'b0, ex2exmem_wb_en_i, ex2exmem_wb_en_o, refresh_flag);
    DFF #(32) u_DFF_3 (clk, rest, `DEFAULT_32_ZERO, ex2exmem_mem_addr_i, ex2exmem_mem_addr_o, refresh_flag);
    DFF #(7) u_DFF_4 (clk, rest, 7'b0, ex2exmem_opcode_i, ex2exmem_opcode_o, refresh_flag);
    DFF #(3) u_DFF_5 (clk, rest, 3'b0, ex2exmem_funct3_i, ex2exmem_funct3_o, refresh_flag);
    DFF #(5) u_DFF_6 (clk, rest, `DEFAULT_5_ZERO, ex2exmem_rd_i, ex2exmem_rd_o, refresh_flag);
    DFF #(5) u_DFF_7 (clk, rest, `DEFAULT_5_ZERO, ex2exmem_rs1_i, ex2exmem_rs1_o, refresh_flag);
    DFF #(5) u_DFF_8 (clk, rest, `DEFAULT_5_ZERO, ex2exmem_rs2_i, ex2exmem_rs2_o, refresh_flag);

endmodule
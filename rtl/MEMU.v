`include "global.v"
`include "riscv_define.v"

module MEMU(
    // from EXMUM
    input wire exmem2mem_wb_en_i,  // 写回使能信号
    input wire[`WORD_ADDR] exmem2mem_mem_addr_i,  // 访问的地址
    input wire[`RISCV_OPCODE] exmem2mem_opcode_i, // 操作码
    input wire[`RISCV_FUNCT3] exmem2mem_funct3_i,
    input wire[`RISCV_RD]  exmem2mem_rd_i,        // rd寄存器
    input wire[`RISCV_RS1] exmem2mem_rs1_i,       // rs1寄存器
    input wire[`RISCV_RS2] exmem2mem_rs2_i,       // rs2寄存器
    // to regs
    output wire mem2regs_wb_en_o,
    output wire[`RISCV_RD] mem2regs_rd_o,
    output wire[`WORD_DATA] mem2regs_rd_data_o
);
    wire[`WORD_DATA] read_data;

    data_ram u_data_ram(
        .idex2mem_addr (idex2mem_addr),
        .ram2mem_data  (read_data    )
    );
    
    always @(*) begin
        mem2regs_wb_en_o = `DISABLE;
        case(exmem2mem_opcode_i)
            `INS_TYPE_L:begin
                case(exmem2mem_funct3_i)
                    `INS_LB:begin
                        mem2regs_wb_en_o = `ENABLE;
                        mem2regs_rd_o = exmem2mem_rd_i;
                        mem2regs_rd_data_o = read_data;
                    end
                endcase
            end
        endcase
    end
endmodule
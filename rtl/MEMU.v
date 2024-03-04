`include "global.v"
`include "riscv_define.v"

module MEMU(
    // from EXMUM
    input wire exmem2mem_wb_en_i,  // 写回使能信号
    input wire exmem2mem_we_i,     // 写内存使能信号
    input wire[`WORD_DATA] exmem2mem_data_i, // 写内存的数据
    input wire[`WORD_ADDR] exmem2mem_mem_addr_i,  // 访问的地址
    input wire[`RISCV_OPCODE] exmem2mem_opcode_i, // 操作码
    input wire[`RISCV_FUNCT3] exmem2mem_funct3_i,
    input wire[`RISCV_RD]  exmem2mem_rd_i,        // rd寄存器
    input wire[`RISCV_RS1] exmem2mem_rs1_i,       // rs1寄存器
    input wire[`RISCV_RS2] exmem2mem_rs2_i,       // rs2寄存器
    // to regs
    output reg mem2regs_wb_en_o,
    output reg[`RISCV_RD] mem2regs_rd_o,
    output reg[`WORD_DATA] mem2regs_rd_data_o

    // output wire[`WORD_DATA] mem2regs_passbynetwork_o, // 数据旁路
    // from EX
    // input wire[`WORD_DATA] ex2mem_passbynetwork_rd_i // 数据旁路选择地址
);
    wire[`WORD_DATA] read_data;

    data_ram u_data_ram(
        .mem2ram_we                (exmem2mem_we_i           ),
        .mem2ram_addr              (exmem2mem_mem_addr_i     ),
        .mem2ram_data              (exmem2mem_data_i         ),
        .ram2mem_data              (read_data                )
    );
    
    
    always @(*) begin // 回写判断
        mem2regs_wb_en_o = `DISABLE;
        case(exmem2mem_opcode_i)
            `INS_TYPE_L:begin
                case(exmem2mem_funct3_i)
                    `INS_LB:begin // 符号位扩展
                        mem2regs_wb_en_o = `ENABLE;
                        mem2regs_rd_o = exmem2mem_rd_i;
                        mem2regs_rd_data_o = {{24{read_data[7]}}, read_data[7:0]};
                    end
                    `INS_LH:begin // 符号位扩展
                        mem2regs_wb_en_o = `ENABLE;
                        mem2regs_rd_o = exmem2mem_rd_i;
                        mem2regs_rd_data_o = {{16{read_data[15]}}, read_data[15:0]};
                    end
                    `INS_LW:begin // 64位需要符号位扩展
                        mem2regs_wb_en_o = `ENABLE;
                        mem2regs_rd_o = exmem2mem_rd_i;
                        mem2regs_rd_data_o = {read_data[31:0]};
                    end
                    `INS_LBU:begin // 0扩展
                        mem2regs_wb_en_o = `ENABLE;
                        mem2regs_rd_o = exmem2mem_rd_i;
                        mem2regs_rd_data_o = {{24{1'b0}}, read_data[7:0]};
                    end
                    `INS_LHU:begin // 0扩展
                        mem2regs_wb_en_o = `ENABLE;
                        mem2regs_rd_o = exmem2mem_rd_i;
                        mem2regs_rd_data_o = {{16{1'b0}}, read_data[15:0]};
                    end
                endcase
            end
            `INS_TYPE_S:begin
                case(exmem2mem_funct3_i)
                    `INS_SB:begin
                        mem2regs_wb_en_o = `DISABLE;
                        mem2regs_rd_o = `DEFAULT_5_ZERO;
                        mem2regs_rd_data_o = `DEFAULT_32_ZERO;
                    end
                endcase
            end
            default:begin
                mem2regs_rd_o = `DEFAULT_5_ZERO;
                mem2regs_rd_data_o = `DEFAULT_32_ZERO;
            end
        endcase
    end
endmodule
`include "global.v"
`include "riscv_define.v"

module EXU(
    // from ID/EX
    input wire[`WORD_ADDR] idex2ex_id_ins_i,
    input wire[`WORD_ADDR] idex2ex_id_addr_i,

    input wire[`WORD_ADDR] idex2ex_source1_i,
    input wire[`WORD_ADDR] idex2ex_source2_i,    
    input wire[`REGS_ADDR] idex2ex_rd_addr_i,

    input wire[`RISCV_OPCODE] idex2ex_opcode_i,
    input wire[`RISCV_RD] idex2ex_rd_i,
    input wire[`RISCV_RS1] idex2ex_rs1_i,
    input wire[`RISCV_RS2] idex2ex_rs2_i,// 暂未使用
    input wire[`RISCV_FUNCT3] idex2ex_funct3_i,
    //I
    input wire[`WORD_DATA] idex2ex_imm_i_i,
    //SB
    input wire[`WORD_DATA] idex2ex_imm_sb_i,
    //UJ
    input wire[`WORD_DATA] idex2ex_imm_uj_i,
    //S
    input wire[`WORD_DATA] idex2ex_imm_s_i,
    // to regs
    output reg ex2regs_wb_en_o,
    // to PC
    output reg[`WORD_ADDR] ex2pc_jump_addr_o,
    // to CU
    output reg ex2cu_jump_en_o,
    // from CU
    input wire cu2ex_wb_en_i,
    input wire cu2ex_mem_en_i,
    // to EXMEMU
    output reg ex2exmem_wb_en_o,
    output reg ex2exmem_mem_en_o,
    output reg ex2exmem_we_o,                   // 访问内存的写使能
    output reg[`WORD_DATA] ex2exmem_data_o,     // 访问内存的写数据
    output reg[`WORD_ADDR] ex2exmem_mem_addr_o, // 访问的地址
    output reg[`RISCV_OPCODE] ex2exmem_opcode_o, // 操作码
    output reg[`RISCV_FUNCT3] ex2exmem_funct3_o,
    output reg[`RISCV_RD]  ex2exmem_rd_o,   // rd寄存器
    output wire[`RISCV_RS1] ex2exmem_rs1_o,  // rs1寄存器
    output wire[`RISCV_RS2] ex2exmem_rs2_o,   // rs2寄存器
    // to regs
    output reg[`REGS_ADDR] ex2regs_rd_addr_o,
    output reg[`WORD_DATA] ex2regs_rd_data_o
    // output reg ex2regs_mem_rd_o,
    // to MEM
    // output reg[`WORD_ADDR] ex2mem_passbynetwork_rd_o
);
    wire [`WORD_DATA] ALU_add;
    wire [`WORD_DATA] ALU_sub;
    wire [`WORD_DATA] ALU_and;
    wire [`WORD_DATA] ALU_or;
    wire [`WORD_DATA] ALU_xor;
    wire [`WORD_DATA] ALU_sll;
    wire [`WORD_DATA] ALU_srl;
    wire [`WORD_DATA] ALU_sra;
    wire [`WORD_DATA] ALU_slt;
    wire [`WORD_DATA] ALU_sltu;
    wire [`WORD_DATA] ALU_add_s_sb;
    wire ALU_beq;
    wire ALU_bne;
    wire ALU_blt;
    wire ALU_bge;
    wire ALU_bltu;
    wire ALU_bgeu;

    ALU u_ALU(
        .ALU_source1   (idex2ex_source1_i ),
        .ALU_source2   (idex2ex_source2_i ),
        .ALU_imm_s     (idex2ex_imm_s_i   ), // 转为该指令
        .ALU_add       (ALU_add           ),
        .ALU_sub       (ALU_sub           ),
        .ALU_and       (ALU_and           ),
        .ALU_or        (ALU_or            ),
        .ALU_xor       (ALU_xor           ),
        .ALU_sll       (ALU_sll           ),
        .ALU_srl       (ALU_srl           ),
        .ALU_sra       (ALU_sra           ),
        .ALU_slt       (ALU_slt           ),
        .ALU_sltu      (ALU_sltu          ),
        .ALU_beq       (ALU_beq           ),
        .ALU_bne       (ALU_bne           ),
        .ALU_blt       (ALU_blt           ),
        .ALU_bge       (ALU_bge           ),
        .ALU_bltu      (ALU_bltu          ),
        .ALU_bgeu      (ALU_bgeu          ),
        .ALU_add_s_sb  (ALU_add_s_sb      )
    );
    
    // IF_WB_MUX u_IF_WB_MUX(
    //     .exif_wb_en_i      (exif_wb_en_o      ),
    //     .exif_mem_en_i     (exif_mem_en_o     ),
    //     .ex2mux_rd_addr_i  (ex2regs_rd_addr_o  ),
    //     .ex2mux_rd_data_i  (ex2regs_rd_data_o  ),
    //     .ex2regs_rd_addr_o (ex2regs_rd_addr_o ),
    //     .ex2regs_rd_data_o (ex2regs_rd_data_o )
    // );
    

    always @(*) begin
        ex2regs_wb_en_o = cu2ex_wb_en_i; // 写回指示
        ex2exmem_wb_en_o = `DISABLE;
        ex2exmem_mem_en_o = `DISABLE;
        ex2exmem_we_o = `DISABLE;
        // ex2regs_mem_rd_o = `DISABLE;
        case(idex2ex_opcode_i)
            `INS_TYPE_I:begin
                case(idex2ex_funct3_i)
                    `INS_ADDI:begin//ADDI
                        ex2regs_rd_addr_o = idex2ex_rd_addr_i;
                        ex2regs_rd_data_o = ALU_add;
                    end
                    `INS_SLTI:begin//SLTI
                        ex2regs_rd_addr_o = idex2ex_rd_addr_i;
                        ex2regs_rd_data_o = ALU_slt;
                    end
                    `INS_SLTIU:begin//SLTIU
                        ex2regs_rd_addr_o = idex2ex_rd_addr_i;
                        ex2regs_rd_data_o = ALU_sltu;
                    end
                    `INS_XORI:begin//XORI
                        ex2regs_rd_addr_o = idex2ex_rd_addr_i;
                        ex2regs_rd_data_o = ALU_xor;
                    end
                    `INS_ORI:begin//ORI
                        ex2regs_rd_addr_o = idex2ex_rd_addr_i;
                        ex2regs_rd_data_o = ALU_or;
                    end
                    `INS_ANDI:begin//ANDI
                        ex2regs_rd_addr_o = idex2ex_rd_addr_i;
                        ex2regs_rd_data_o = ALU_and;
                    end
                    `INS_SLLI:begin//SLLI
                        ex2regs_rd_addr_o = idex2ex_rd_addr_i;
                        ex2regs_rd_data_o = ALU_sll; 
                    end
                    `INS_SRLI,`INS_SRAI:begin//SRLI,SRAI
                        if (idex2ex_source2_i[11:5] == `INS_SRLI_H) begin
                            ex2regs_rd_addr_o = idex2ex_rd_addr_i;
                            ex2regs_rd_data_o = ALU_srl;
                        end else if (idex2ex_source2_i[11:5] == `INS_SRAI_H) begin
                            ex2regs_rd_addr_o = idex2ex_rd_addr_i;
                            ex2regs_rd_data_o = ALU_sra;
                        end
                    end
                    default:begin
                        ex2regs_rd_addr_o = `DEFAULT_5_ZERO;
                        ex2regs_rd_data_o = `DEFAULT_32_ZERO;
                    end
                endcase
            end
            `INS_TYPE_R_M:begin
                case(idex2ex_funct3_i)
                    `INS_ADD,`INS_SUB:begin//ADD
                        if (idex2ex_imm_i_i[11:5] == `INS_ADD_H) begin
                            ex2regs_rd_addr_o = idex2ex_rd_addr_i;
                            ex2regs_rd_data_o = ALU_add;
                        end else if (idex2ex_imm_i_i[11:5] == `INS_SUB_H) begin
                            ex2regs_rd_addr_o = idex2ex_rd_addr_i;
                            ex2regs_rd_data_o = ALU_sub;
                        end
                    end
                    `INS_SLL:begin
                        ex2regs_rd_addr_o = idex2ex_rd_addr_i;
                        ex2regs_rd_data_o = ALU_sll;
                    end
                    `INS_SLT:begin
                        ex2regs_rd_addr_o = idex2ex_rd_addr_i;
                        ex2regs_rd_data_o = ALU_slt;    
                    end
                    `INS_SLTU:begin
                        ex2regs_rd_addr_o = idex2ex_rd_addr_i;
                        ex2regs_rd_data_o = ALU_sltu;  
                    end
                    `INS_XOR:begin
                        ex2regs_rd_addr_o = idex2ex_rd_addr_i;
                        ex2regs_rd_data_o = ALU_xor;  
                    end
                    `INS_SRL,`INS_SRA:begin
                        if (idex2ex_imm_i_i[11:5] == `INS_SRL_H) begin
                            ex2regs_rd_addr_o = idex2ex_rd_addr_i;
                            ex2regs_rd_data_o = ALU_srl;
                        end else if (idex2ex_imm_i_i[11:5] == `INS_SRA_H) begin
                            ex2regs_rd_addr_o = idex2ex_rd_addr_i;
                            ex2regs_rd_data_o = ALU_sra;
                        end
                    end
                    `INS_OR:begin
                        ex2regs_rd_addr_o = idex2ex_rd_addr_i;
                        ex2regs_rd_data_o = ALU_or;  
                    end
                    `INS_AND:begin
                        ex2regs_rd_addr_o = idex2ex_rd_addr_i;
                        ex2regs_rd_data_o = ALU_and;  
                    end
                    default:begin
                        ex2regs_rd_addr_o = idex2ex_rd_addr_i;
                        ex2regs_rd_data_o = `DEFAULT_32_ZERO;
                    end
                endcase
            end
            `INS_TYPE_B:begin
                case(idex2ex_funct3_i)
                    `INS_BEQ:begin//BEQ
                        ex2cu_jump_en_o = (ALU_beq == `ENABLE) ? `ENABLE : `DISABLE;
                        ex2pc_jump_addr_o = (ALU_beq == `ENABLE) ? (idex2ex_id_addr_i + idex2ex_imm_sb_i) : `DEFAULT_32_ZERO;
                        ex2regs_rd_addr_o = `DEFAULT_5_ZERO;
                        ex2regs_rd_data_o = `DEFAULT_32_ZERO;
                    end
                    `INS_BNE:begin//BNE
                        ex2cu_jump_en_o = (ALU_bne == `ENABLE) ? `ENABLE : `DISABLE;
                        ex2pc_jump_addr_o = (ALU_bne == `ENABLE) ? (idex2ex_id_addr_i + idex2ex_imm_sb_i) : `DEFAULT_32_ZERO;
                        ex2regs_rd_addr_o = `DEFAULT_5_ZERO;
                        ex2regs_rd_data_o = `DEFAULT_32_ZERO;
                    end
                    `INS_BLT:begin//BLT
                        ex2cu_jump_en_o = (ALU_blt == `ENABLE) ? `ENABLE : `DISABLE;
                        ex2pc_jump_addr_o = (ALU_blt == `ENABLE) ? (idex2ex_id_addr_i + idex2ex_imm_sb_i) : `DEFAULT_32_ZERO;
                        ex2regs_rd_addr_o = `DEFAULT_5_ZERO;
                        ex2regs_rd_data_o = `DEFAULT_32_ZERO;
                    end
                    `INS_BGE:begin//BGE
                        ex2cu_jump_en_o = (ALU_bge == `ENABLE) ? `ENABLE : `DISABLE;
                        ex2pc_jump_addr_o = (ALU_bge == `ENABLE) ? (idex2ex_id_addr_i + idex2ex_imm_sb_i) : `DEFAULT_32_ZERO;
                        ex2regs_rd_addr_o = `DEFAULT_5_ZERO;
                        ex2regs_rd_data_o = `DEFAULT_32_ZERO;
                    end
                    `INS_BLTU:begin//BLTU
                        ex2cu_jump_en_o = (ALU_bltu == `ENABLE) ? `ENABLE : `DISABLE;
                        ex2pc_jump_addr_o = (ALU_bltu == `ENABLE) ? (idex2ex_id_addr_i + idex2ex_imm_sb_i) : `DEFAULT_32_ZERO;
                        ex2regs_rd_addr_o = `DEFAULT_5_ZERO;
                        ex2regs_rd_data_o = `DEFAULT_32_ZERO;
                    end
                    `INS_BGEU:begin//BGEU
                        ex2cu_jump_en_o = (ALU_bgeu == `ENABLE) ? `ENABLE : `DISABLE;
                        ex2pc_jump_addr_o = (ALU_bgeu == `ENABLE) ? (idex2ex_id_addr_i + idex2ex_imm_sb_i) : `DEFAULT_32_ZERO;
                        ex2regs_rd_addr_o = `DEFAULT_5_ZERO;
                        ex2regs_rd_data_o = `DEFAULT_32_ZERO;
                    end
                    default:begin
                        ex2cu_jump_en_o = `DISABLE;
                        ex2pc_jump_addr_o = `DEFAULT_32_ZERO;
                        ex2regs_rd_addr_o = `DEFAULT_5_ZERO;
                        ex2regs_rd_data_o = `DEFAULT_32_ZERO;
                    end
                endcase
            end
            `INS_TYPE_JAL:begin
                // 此处可能需要判断合法性
                ex2cu_jump_en_o = `ENABLE;
                ex2pc_jump_addr_o = idex2ex_id_addr_i + idex2ex_imm_uj_i;
                ex2regs_rd_addr_o = idex2ex_rd_addr_i;
                ex2regs_rd_data_o = idex2ex_id_addr_i + `A_PC;
            end
            `INS_TYPE_JALR:begin
                if (idex2ex_funct3_i == 3'b000) begin
                    ex2cu_jump_en_o = `ENABLE;
                    ex2pc_jump_addr_o = (idex2ex_source1_i + idex2ex_source2_i) & 32'hFFFFFFFE;
                    ex2regs_rd_addr_o = idex2ex_rd_addr_i;
                    ex2regs_rd_data_o = idex2ex_id_addr_i + `A_PC;
                end
            end
            `INS_TYPE_AUIPC:begin
                ex2cu_jump_en_o = `ENABLE;
                ex2pc_jump_addr_o = idex2ex_id_addr_i + idex2ex_source2_i;
                ex2regs_rd_addr_o = idex2ex_rd_addr_i;
                ex2regs_rd_data_o = idex2ex_id_addr_i + idex2ex_source2_i;
            end
            // 访存
            `INS_TYPE_L:begin 
                // ex2regs_mem_rd_o = `ENABLE;
                case(idex2ex_funct3_i)
                    `INS_LB,`INS_LH,`INS_LW,`INS_LBU,`INS_LHU:begin // 加载指令需要修改
                        ex2exmem_opcode_o = idex2ex_opcode_i;
                        ex2exmem_funct3_o = idex2ex_funct3_i;
                        ex2exmem_mem_addr_o = ALU_add;
                        ex2exmem_rd_o = idex2ex_rd_addr_i;
                        ex2exmem_wb_en_o = `ENABLE;
                        ex2exmem_mem_en_o = `ENABLE;
                        // ex2mem_passbynetwork_rd_o = idex2ex_rd_addr_i; // 数据旁路地址
                    end
                    default:begin
                    end
                endcase
            end
            `INS_TYPE_S:begin
                case(idex2ex_funct3_i)
                    `INS_SB:begin
                        ex2exmem_opcode_o = idex2ex_opcode_i;
                        ex2exmem_funct3_o = idex2ex_funct3_i;
                        ex2exmem_mem_addr_o = ALU_add_s_sb;  // 访问的地址
                        ex2exmem_data_o = idex2ex_source2_i; // 准备存储的数据
                        ex2exmem_wb_en_o = `DISABLE;
                        ex2exmem_mem_en_o = `ENABLE;
                        ex2exmem_we_o = `ENABLE;
                        // ex2mem_passbynetwork_rd_o = idex2ex_source2_i; // 数据旁路地址
                    end
                    default:begin
                    end
                endcase
            end
            default:begin
                ex2cu_jump_en_o = `DISABLE;
                ex2pc_jump_addr_o = `DEFAULT_32_ZERO;
                ex2regs_rd_addr_o = `DEFAULT_5_ZERO;
                ex2regs_rd_data_o = `DEFAULT_32_ZERO;
                ex2exmem_data_o = `DEFAULT_32_ZERO;
            end
        endcase 
    end

endmodule
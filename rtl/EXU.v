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
    // to regs
    output reg[`REGS_ADDR] ex2regs_rd_addr_o,
    output reg[`WORD_DATA] ex2regs_rd_data_o,
    // to PC
    output reg[`WORD_ADDR] ex2pc_jump_addr_o,
    // to CU
    output reg ex2cu_jump_en_o
);
    wire [`WORD_DATA] ALU_add;
    wire [`WORD_DATA] ALU_sub;
    wire [`WORD_DATA] ALU_and;
    wire [`WORD_DATA] ALU_or;
    wire [`WORD_DATA] ALU_xor;
    wire [`WORD_DATA] ALU_sll;
    wire [`WORD_DATA] ALU_srl;
    wire [`WORD_DATA] ALU_stl;
    wire [`WORD_DATA] ALU_stlu;
    wire  ALU_beq;

    ALU u_ALU(
        .ALU_source1 (idex2ex_source1_i ),
        .ALU_source2 (idex2ex_source2_i ),
        .ALU_add     (ALU_add           ),
        .ALU_sub     (ALU_sub           ),
        .ALU_and     (ALU_and           ),
        .ALU_or      (ALU_or            ),
        .ALU_xor     (ALU_xor           ),
        .ALU_sll     (ALU_sll           ),
        .ALU_srl     (ALU_srl           ),
        .ALU_stl     (ALU_stl           ),
        .ALU_stlu    (ALU_stlu          ),
        .ALU_beq     (ALU_beq           )
    );
    

    always @(*) begin
        case(idex2ex_opcode_i)
            `INS_TYPE_I:begin
                case(idex2ex_funct3_i)
                    `INS_ADDI:begin//ADDI
                        ex2regs_rd_addr_o = idex2ex_rd_addr_i;
                        ex2regs_rd_data_o = ALU_add;
                    end
                    `INS_SLTI:begin//SLTI
                        ex2regs_rd_addr_o = idex2ex_rd_addr_i;
                        ex2regs_rd_data_o = ALU_stl;
                    end
                    `INS_SLTIU:begin//SLTIU
                        ex2regs_rd_addr_o = idex2ex_rd_addr_i;
                        ex2regs_rd_data_o = ALU_stlu;
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
                    `INS_SRLI:begin//SRLI
                        ex2regs_rd_addr_o = idex2ex_rd_addr_i;
                        ex2regs_rd_data_o = ALU_srl;
                    end
                    default:begin
                        ex2regs_rd_addr_o = `DEFAULT_5_ZERO;
                        ex2regs_rd_data_o = `DEFAULT_32_ZERO;
                    end
                endcase
            end
            `INS_TYPE_R_M:begin
                case(idex2ex_funct3_i)
                    `INS_ADD:begin//ADD
                        ex2regs_rd_addr_o = idex2ex_rd_addr_i;
                        ex2regs_rd_data_o = ALU_add;
                    end
                    default:begin
                        ex2regs_rd_addr_o = idex2ex_rd_addr_i;
                        ex2regs_rd_data_o = `DEFAULT_32_ZERO;
                    end
                endcase
            end
            `INS_TYPE_B:begin
                case(idex2ex_funct3_i)
                    `INS_BEQ:begin
                        ex2cu_jump_en_o = (ALU_beq == `ENABLE) ? `ENABLE : `DISABLE;
                        ex2pc_jump_addr_o = (ALU_beq == `ENABLE) ? (idex2ex_id_addr_i + idex2ex_imm_sb_i) : `DEFAULT_32_ZERO;
                        ex2regs_rd_addr_o = `DEFAULT_5_ZERO;
                        ex2regs_rd_data_o = `DEFAULT_32_ZERO;
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
            end
        endcase 
    end

endmodule
`include "global.v"
`include "riscv_define.v"

module IDU(
    // from IF/ID
    input wire[`WORD_ADDR] ifid2id_ins_i,
    input wire[`WORD_ADDR] ifid2id_addr_i,
    // from regs
    input wire[`WORD_DATA] regs2id_rs1_data_i,
    input wire[`WORD_DATA] regs2id_rs2_data_i,
    // to regs
    output reg[`REGS_ADDR] id2regs_rs1_addr_o,
    output reg[`REGS_ADDR] id2regs_rs2_addr_o,
    // to id/ex
    output reg[`WORD_ADDR] id2idex_source1_o,
    output reg[`WORD_ADDR] id2idex_source2_o,
    output reg[`WORD_ADDR] id2idex_ins_o,
    output reg[`WORD_ADDR] id2idex_addr_o,
    output reg[`REGS_ADDR] id2idex_rd_addr_o,
    
    output wire[`RISCV_OPCODE] id2idex_opcode_o,
    output wire[`RISCV_RD] id2idex_rd_o,
    output wire[`RISCV_RS1] id2idex_rs1_o,
    output wire[`RISCV_RS2] id2idex_rs2_o,
    output wire[`RISCV_FUNCT3] id2idex_funct3_o,
    //I
    output reg[`WORD_DATA] id2idex_imm_i_o,
    //SB
    output reg[`WORD_DATA] id2idex_imm_sb_o,
    //UJ
    output reg[`WORD_DATA] id2idex_imm_uj_o,
    // to CU
    output reg id2cu_wb_en_o, // 写回使能
    output reg id2cu_mem_en_o  // 访存使能
);

    wire[`RISCV_IMMI] imm_i;
    wire[`RISCV_IMMSB] imm_sb;
    wire[`RISCV_IMMUJ] imm_uj;

    assign id2idex_opcode_o = ifid2id_ins_i[6:0];
    assign id2idex_rd_o = ifid2id_ins_i[11:7];
    assign id2idex_funct3_o = ifid2id_ins_i[14:12];
    assign id2idex_rs1_o = ifid2id_ins_i[19:15];
    assign id2idex_rs2_o = ifid2id_ins_i[24:20];
    // 专属的指令都先无符号位扩展
    //I
    assign imm_i = ifid2id_ins_i[31:20]; // 暂时没用 // 11:0
    //SB
    assign imm_sb = {ifid2id_ins_i[31], ifid2id_ins_i[7], ifid2id_ins_i[30:25], ifid2id_ins_i[11:8], 1'b0}; // 12:0
    //UJ
    assign imm_uj = {ifid2id_ins_i[31], ifid2id_ins_i[19:12], ifid2id_ins_i[20], ifid2id_ins_i[30:21], 1'b0};// 20:0


    always @(*) begin
        id2idex_ins_o = ifid2id_ins_i;
        id2idex_addr_o = ifid2id_addr_i;
        id2cu_wb_en_o = `DISABLE;
        id2cu_mem_en_o = `DISABLE;
        case(id2idex_opcode_o)
            `INS_TYPE_I:begin
                case(id2idex_funct3_o)
                    `INS_ADDI,`INS_SLTI,`INS_SLTIU,`INS_XORI,`INS_ORI,`INS_ANDI,`INS_SLLI,`INS_SRLI:begin
                        //ADDI,SLTI,SLTIU,XORI,ORI,ANDI,SLLI,SRLI
                        id2regs_rs1_addr_o = id2idex_rs1_o;
                        id2regs_rs2_addr_o = `DEFAULT_5_ZERO;
                        id2idex_source1_o = regs2id_rs1_data_i;
                        id2idex_source2_o = {{20{imm_i[11]}}, imm_i};//imm符号位扩展
                        id2idex_rd_addr_o = id2idex_rd_o;
                        id2cu_wb_en_o = `ENABLE;
                    end
                    default:begin
                        id2regs_rs1_addr_o = `DEFAULT_5_ZERO;
                        id2regs_rs2_addr_o = `DEFAULT_5_ZERO;
                        id2idex_source1_o = `DEFAULT_32_ZERO;
                        id2idex_source2_o = `DEFAULT_32_ZERO;
                        id2idex_rd_addr_o = `DEFAULT_5_ZERO;
                        id2cu_wb_en_o = `DISABLE;
                    end
                endcase
            end
            `INS_TYPE_R_M:begin
                case(id2idex_funct3_o)
                    `INS_ADD:begin//ADD
                        id2regs_rs1_addr_o = id2idex_rs1_o;
                        id2regs_rs2_addr_o = id2idex_rs2_o;
                        id2idex_source1_o = regs2id_rs1_data_i;
                        id2idex_source2_o = regs2id_rs2_data_i;
                        id2idex_rd_addr_o = id2idex_rd_o;
                        id2cu_wb_en_o = `ENABLE;
                    end
                    default:begin
                        id2regs_rs1_addr_o = `DEFAULT_5_ZERO;
                        id2regs_rs2_addr_o = `DEFAULT_5_ZERO;
                        id2idex_source1_o = `DEFAULT_32_ZERO;
                        id2idex_source2_o = `DEFAULT_32_ZERO;
                        id2idex_rd_addr_o = `DEFAULT_5_ZERO;
                        id2cu_wb_en_o = `DISABLE;
                    end
                endcase
            end
            `INS_TYPE_B:begin
                case(id2idex_funct3_o)
                    `INS_BEQ,`INS_BNE,`INS_BLT,`INS_BGE,`INS_BLTU,`INS_BGEU:begin
                        //BEQ,BNE,BLT,BGE,BLTU,BGEU
                        id2regs_rs1_addr_o = id2idex_rs1_o;
                        id2regs_rs2_addr_o = id2idex_rs2_o;
                        id2idex_source1_o = regs2id_rs1_data_i;
                        id2idex_source2_o = regs2id_rs2_data_i;
                        id2idex_imm_sb_o = {{19{imm_sb[12]}}, imm_sb};// 符号位扩展
                        id2idex_rd_addr_o = `DEFAULT_5_ZERO;
                        id2cu_wb_en_o = `DISABLE;
                    end
                    default:begin
                        id2regs_rs1_addr_o = `DEFAULT_5_ZERO;
                        id2regs_rs2_addr_o = `DEFAULT_5_ZERO;
                        id2idex_source1_o = `DEFAULT_32_ZERO;
                        id2idex_source2_o = `DEFAULT_32_ZERO;
                        id2idex_rd_addr_o = `DEFAULT_5_ZERO;
                        id2cu_wb_en_o = `DISABLE;
                    end
                endcase
            end
            `INS_TYPE_UJ:begin
                id2idex_rd_addr_o = id2idex_rd_o;
                id2idex_imm_uj_o = {{11{imm_uj[20]}}, imm_uj}; // 符号位扩展
                id2cu_wb_en_o = `DISABLE;
            end
            `INS_TYPE_L:begin
                case(id2idex_funct3_o)
                    `INS_LB:begin
                        id2regs_rs1_addr_o = id2idex_rs1_o;
                        id2regs_rs2_addr_o = `DEFAULT_5_ZERO;
                        id2idex_source1_o = regs2id_rs1_data_i;
                        id2idex_source2_o = {{20{imm_i[11]}}, imm_i};//imm符号位扩展
                        id2idex_rd_addr_o = id2idex_rd_o;
                        id2cu_wb_en_o = `ENABLE;
                    end
                    default:begin
                        id2regs_rs1_addr_o = `DEFAULT_5_ZERO;
                        id2regs_rs2_addr_o = `DEFAULT_5_ZERO;
                        id2idex_source1_o = `DEFAULT_32_ZERO;
                        id2idex_source2_o = `DEFAULT_32_ZERO;
                        id2idex_rd_addr_o = `DEFAULT_5_ZERO;
                        id2cu_wb_en_o = `DISABLE;
                        id2cu_mem_en_o = `ENABLE;
                    end
                endcase
            end
            default:begin
                id2regs_rs1_addr_o = `DEFAULT_5_ZERO;
                id2regs_rs2_addr_o = `DEFAULT_5_ZERO;
                id2idex_source1_o = `DEFAULT_32_ZERO;
                id2idex_source2_o = `DEFAULT_32_ZERO;
                id2idex_rd_addr_o = `DEFAULT_5_ZERO;
                id2cu_wb_en_o = `DISABLE;
            end
        endcase 
    end

endmodule
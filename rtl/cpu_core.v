`include "global.v"

module cpu_core(
    input wire clk,
    input wire rest,
    // input wire[`WORD_ADDR] pc_addr_i
    // from rom
    input wire[`WORD_ADDR] rom2if_ins_i,
    // to rom
    output wire [`WORD_ADDR] if2rom_ins_o
);
    // pc_regs
    wire[`WORD_ADDR] pc2if_addr_o;

    PC u_pc_reg(
        .clk               (clk              ),
        .rest              (rest             ),
        .pc2if_addr_o      (pc2if_addr_o     ),
        .cu2pc_jump_en_i   (cu2pc_jump_en_o  ),
        .ex2pc_jump_addr_i (ex2pc_jump_addr_o)
    );

    // IF
    wire[`WORD_ADDR] if2ifid_addr_o;
    wire[`WORD_ADDR] if2ifid_ins_o;

    IFU u_IFU(
        .pc2if_addr_i   (pc2if_addr_o   ),
        .rom2if_ins_i   (rom2if_ins_i   ),
        .if2rom_ins_o   (if2rom_ins_o   ),
        .if2ifid_addr_o (if2ifid_addr_o ),
        .if2ifid_ins_o  (if2ifid_ins_o  )
    );
    
    // IF/ID
    wire[`WORD_ADDR] ifid2id_ins_o;
    wire[`WORD_ADDR] ifid2id_addr_o;

    IFIDU u_IFIDU(
        .clk                (clk               ),
        .rest               (rest              ),
        .if2ifid_addr_i     (if2ifid_addr_o    ),
        .if2ifid_ins_i      (if2ifid_ins_o     ),
        .ifid2id_ins_o      (ifid2id_ins_o     ),
        .ifid2id_addr_o     (ifid2id_addr_o    ),
        .cu2_refresh_flag_i (cu2_refresh_flag_o)
    );

    // ID
    wire[`REGS_ADDR] id2regs_rs1_addr_o;
    wire[`REGS_ADDR] id2regs_rs2_addr_o;

    wire[`WORD_ADDR] id2idex_source1_o;
    wire[`WORD_ADDR] id2idex_source2_o;
    wire[`WORD_ADDR] id2idex_ins_o;
    wire[`WORD_ADDR] id2idex_addr_o;
    wire[`REGS_ADDR] id2idex_rd_addr_o;
    wire[`RISCV_OPCODE] id2idex_opcode_o;
    wire[`RISCV_RD] id2idex_rd_o;
    wire[`RISCV_RS1] id2idex_rs1_o;
    wire[`RISCV_RS2] id2idex_rs2_o;
    wire[`RISCV_FUNCT3] id2idex_funct3_o;

    wire[`WORD_DATA] id2idex_imm_i_o;
    wire[`WORD_DATA] id2idex_imm_sb_o;
    wire[`WORD_DATA] id2idex_imm_uj_o;
    
    IDU u_IDU(
        .ifid2id_ins_i      (ifid2id_ins_o      ),
        .ifid2id_addr_i     (ifid2id_addr_o     ),
        .regs2id_rs1_data_i (regs2id_rs1_data_o ),
        .regs2id_rs2_data_i (regs2id_rs2_data_o ),
        .id2regs_rs1_addr_o (id2regs_rs1_addr_o ),
        .id2regs_rs2_addr_o (id2regs_rs2_addr_o ),
        .id2idex_source1_o  (id2idex_source1_o  ),
        .id2idex_source2_o  (id2idex_source2_o  ),
        .id2idex_ins_o      (id2idex_ins_o      ),
        .id2idex_addr_o     (id2idex_addr_o     ),
        .id2idex_rd_addr_o  (id2idex_rd_addr_o  ),
        .id2idex_opcode_o   (id2idex_opcode_o   ),
        .id2idex_rd_o       (id2idex_rd_o       ),
        .id2idex_rs1_o      (id2idex_rs1_o      ),
        .id2idex_rs2_o      (id2idex_rs2_o      ),
        .id2idex_funct3_o   (id2idex_funct3_o   ),
        .id2idex_imm_i_o    (id2idex_imm_i_o    ),
        .id2idex_imm_sb_o   (id2idex_imm_sb_o   ),
        .id2idex_imm_uj_o   (id2idex_imm_uj_o   )
    );
    
    
    // ID/EX
    wire[`WORD_ADDR] idex2ex_source1_o;
    wire[`WORD_ADDR] idex2ex_source2_o;
    wire[`WORD_ADDR] idex2ex_id_ins_o;
    wire[`WORD_ADDR] idex2ex_addr_o;
    wire[`REGS_ADDR] idex2ex_rd_addr_o;
    wire[`RISCV_OPCODE] idex2ex_opcode_o;
    wire[`RISCV_RD] idex2ex_rd_o;
    wire[`RISCV_RS1] idex2ex_rs1_o;
    wire[`RISCV_RS2] idex2ex_rs2_o;
    wire[`RISCV_FUNCT3] idex2ex_funct3_o;
    wire[`WORD_DATA] idex2ex_imm_i_o;
    wire[`WORD_DATA] idex2ex_imm_sb_o;
    wire[`WORD_DATA] idex2ex_imm_uj_o;

    IDEXU u_IDEXU(
        .clk                (clk               ),
        .rest               (rest              ),
        .id2idex_source1_i  (id2idex_source1_o ),
        .id2idex_source2_i  (id2idex_source2_o ),
        .id2idex_ins_i      (id2idex_ins_o     ),
        .id2idex_addr_i     (id2idex_addr_o    ),
        .id2idex_rd_addr_i  (id2idex_rd_addr_o ),
        .id2idex_opcode_i   (id2idex_opcode_o  ),
        .id2idex_rd_i       (id2idex_rd_o      ),
        .id2idex_rs1_i      (id2idex_rs1_o     ),
        .id2idex_rs2_i      (id2idex_rs2_o     ),
        .id2idex_funct3_i   (id2idex_funct3_o  ),
        .id2idex_imm_i_i    (id2idex_imm_i_o   ), // I
        .id2idex_imm_sb_i   (id2idex_imm_sb_o  ), // SB
        .id2idex_imm_uj_i   (id2idex_imm_uj_o  ), // UJ
        .idex2ex_source1_o  (idex2ex_source1_o ),
        .idex2ex_source2_o  (idex2ex_source2_o ),
        .idex2ex_id_ins_o   (idex2ex_id_ins_o  ),
        .idex2ex_addr_o     (idex2ex_addr_o    ),
        .idex2ex_rd_addr_o  (idex2ex_rd_addr_o ),
        .idex2ex_opcode_o   (idex2ex_opcode_o  ),
        .idex2ex_rd_o       (idex2ex_rd_o      ),
        .idex2ex_rs1_o      (idex2ex_rs1_o     ),
        .idex2ex_rs2_o      (idex2ex_rs2_o     ),
        .idex2ex_funct3_o   (idex2ex_funct3_o  ),
        .idex2ex_imm_i_o    (idex2ex_imm_i_o   ),
        .idex2ex_imm_sb_o   (idex2ex_imm_sb_o  ),
        .idex2ex_imm_uj_o   (idex2ex_imm_uj_o  ),
        .cu2_refresh_flag_i (cu2_refresh_flag_o)
    );
    
    // EX
    wire[`REGS_ADDR] ex2regs_rd_addr_o;
    wire[`WORD_DATA] ex2regs_rd_data_o;
    wire[`WORD_DATA] ex2pc_jump_addr_o;
    wire ex2cu_jump_en_o;

    EXU u_EXU(
        .idex2ex_id_ins_i  (idex2ex_id_ins_o  ),
        .idex2ex_id_addr_i (idex2ex_addr_o    ),
        .idex2ex_source1_i (idex2ex_source1_o ),
        .idex2ex_source2_i (idex2ex_source2_o ),
        .idex2ex_rd_addr_i (idex2ex_rd_addr_o ),
        .idex2ex_opcode_i  (idex2ex_opcode_o  ),
        .idex2ex_rd_i      (idex2ex_rd_o      ),
        .idex2ex_rs1_i     (idex2ex_rs1_o     ),
        .idex2ex_rs2_i     (idex2ex_rs2_o     ),
        .idex2ex_funct3_i  (idex2ex_funct3_o  ),
        .idex2ex_imm_i_i   (idex2ex_imm_i_o   ),
        .idex2ex_imm_sb_i  (idex2ex_imm_sb_o  ),
        .idex2ex_imm_uj_i  (idex2ex_imm_uj_o  ),
        .ex2regs_rd_addr_o (ex2regs_rd_addr_o ),
        .ex2regs_rd_data_o (ex2regs_rd_data_o ),
        .ex2pc_jump_addr_o (ex2pc_jump_addr_o ),
        .ex2cu_jump_en_o   (ex2cu_jump_en_o   )
    );
    
    // regs
    wire[`WORD_DATA] regs2id_rs1_data_o;
    wire[`WORD_DATA] regs2id_rs2_data_o;

    regs u_regs(
        .clk                (clk                ),
        .rest               (rest               ),
        .id2regs_rs1_addr_i (id2regs_rs1_addr_o ),
        .id2regs_rs2_addr_i (id2regs_rs2_addr_o ),
        .regs2id_rs1_data_o (regs2id_rs1_data_o ),
        .regs2id_rs2_data_o (regs2id_rs2_data_o ),
        .ex2regs_rd_addr_i  (ex2regs_rd_addr_o  ),
        .ex2regs_rd_data_i  (ex2regs_rd_data_o  )
    );
    
    //CU
    wire cu2_refresh_flag_o;
    wire cu2pc_jump_en_o;

    CU u_CU(
        .ex2cu_jump_en_i    (ex2cu_jump_en_o    ),
        .cu2_refresh_flag_o (cu2_refresh_flag_o ),
        .cu2pc_jump_en_o    (cu2pc_jump_en_o    )
    );
    
endmodule
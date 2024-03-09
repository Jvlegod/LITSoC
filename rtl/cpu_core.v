`include "global.v"

module cpu_core(
    input wire clk,
    input wire rest,
    // input wire[`WORD_ADDR] pc_addr_i
    // from rom
    input wire[`WORD_ADDR] rom2if_ins_i,
    // to rom
    output wire [`WORD_ADDR] if2rom_ins_o,
    // to Bus
    output wire bus_m0_req,     
    output wire[`WORD_ADDR] bus_m0_addr,    
    output wire bus_m0_as,      
    output wire bus_m0_rw,      
    output wire[`WORD_DATA] bus_m0_wr_data, 
    input  wire bus_m0_grnt,    
    input  wire bus_rdy
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
    wire[`WORD_DATA] id2idex_imm_s_o;
    
    wire id2cu_wb_en_o;
    wire id2cu_mem_en_o;

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
        .id2idex_imm_uj_o   (id2idex_imm_uj_o   ),
        .id2idex_imm_s_o    (id2idex_imm_s_o    ),
        .id2cu_wb_en_o      (id2cu_wb_en_o      ),
        .id2cu_mem_en_o     (id2cu_mem_en_o     )
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
    wire[`WORD_DATA] idex2ex_imm_s_o;

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
        .id2idex_imm_s_i    (id2idex_imm_s_o   ),
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
        .cu2_refresh_flag_i (cu2_refresh_flag_o),
        .idex2ex_imm_s_o    (idex2ex_imm_s_o   )
    );
    
    // EX
    wire[`REGS_ADDR] ex2regs_rd_addr_o;
    wire[`WORD_DATA] ex2regs_rd_data_o;
    wire[`WORD_ADDR] ex2pc_jump_addr_o;
    wire[`WORD_ADDR] ex2exmem_mem_addr_o;
    wire[`RISCV_OPCODE] ex2exmem_opcode_o;
    wire[`RISCV_FUNCT3] ex2exmem_funct3_o;
    wire[`RISCV_RD]  ex2exmem_rd_o;
    wire[`RISCV_RS1] ex2exmem_rs1_o;
    wire[`RISCV_RS2] ex2exmem_rs2_o;
    wire[`WORD_DATA] ex2exmem_data_o;

    wire ex2cu_jump_en_o;
    wire ex2regs_wb_en_o;
    wire ex2exmem_wb_en_o;
    wire ex2exmem_mem_en_o;
    wire ex2exmem_we_o;

    EXU u_EXU(
        .idex2ex_id_ins_i    (idex2ex_id_ins_o   ),
        .idex2ex_id_addr_i   (idex2ex_addr_o     ),
        .idex2ex_source1_i   (idex2ex_source1_o  ),
        .idex2ex_source2_i   (idex2ex_source2_o  ),
        .idex2ex_rd_addr_i   (idex2ex_rd_addr_o  ),
        .idex2ex_opcode_i    (idex2ex_opcode_o   ),
        .idex2ex_rd_i        (idex2ex_rd_o       ),
        .idex2ex_rs1_i       (idex2ex_rs1_o      ),
        .idex2ex_rs2_i       (idex2ex_rs2_o      ),
        .idex2ex_funct3_i    (idex2ex_funct3_o   ),
        .idex2ex_imm_i_i     (idex2ex_imm_i_o    ),
        .idex2ex_imm_sb_i    (idex2ex_imm_sb_o   ),
        .idex2ex_imm_uj_i    (idex2ex_imm_uj_o   ),
        .idex2ex_imm_s_i     (idex2ex_imm_s_o    ),
        .ex2regs_rd_addr_o   (ex2regs_rd_addr_o  ),
        .ex2regs_wb_en_o     (ex2regs_wb_en_o    ),
        .ex2pc_jump_addr_o   (ex2pc_jump_addr_o  ),
        .ex2cu_jump_en_o     (ex2cu_jump_en_o    ),
        .cu2ex_wb_en_i       (cu2ex_wb_en_o      ),
        .cu2ex_mem_en_i      (cu2ex_mem_en_o     ),
        .ex2exmem_wb_en_o    (ex2exmem_wb_en_o   ),
        .ex2exmem_mem_en_o   (ex2exmem_mem_en_o  ),
        .ex2exmem_we_o       (ex2exmem_we_o      ),
        .ex2exmem_data_o     (ex2exmem_data_o    ),
        .ex2exmem_mem_addr_o (ex2exmem_mem_addr_o),
        .ex2exmem_opcode_o   (ex2exmem_opcode_o  ),
        .ex2exmem_funct3_o   (ex2exmem_funct3_o  ),
        .ex2exmem_rd_o       (ex2exmem_rd_o      ),
        .ex2exmem_rs1_o      (ex2exmem_rs1_o     ),
        .ex2exmem_rs2_o      (ex2exmem_rs2_o     ),
        .ex2regs_rd_data_o   (ex2regs_rd_data_o  )
    );

    // EXMEM
    wire[`WORD_ADDR] exmem2mem_mem_addr_o;
    wire[`WORD_DATA] exmem2mem_data_o;
    wire[`RISCV_OPCODE] exmem2mem_opcode_o;
    wire[`RISCV_FUNCT3] exmem2mem_funct3_o;
    wire[`RISCV_RD]  exmem2mem_rd_o;
    wire[`RISCV_RS1] exmem2mem_rs1_o;
    wire[`RISCV_RS2] exmem2mem_rs2_o;
    wire exmem2mem_wb_en_o;
    wire exmem2mem_we_o;

    EXMEMU u_EXMEMU(
        .clk                  (clk                  ),
        .rest                 (rest                 ),
        .ex2exmem_wb_en_i     (ex2exmem_wb_en_o     ),
        .ex2exmem_mem_en_i    (ex2exmem_mem_en_o    ),
        .ex2exmem_we_i        (ex2exmem_we_o        ),
        .ex2exmem_data_i      (ex2exmem_data_o      ),
        .ex2exmem_mem_addr_i  (ex2exmem_mem_addr_o  ),
        .ex2exmem_opcode_i    (ex2exmem_opcode_o    ),
        .ex2exmem_funct3_i    (ex2exmem_funct3_o    ),
        .ex2exmem_rd_i        (ex2exmem_rd_o        ),
        .ex2exmem_rs1_i       (ex2exmem_rs1_o       ),
        .ex2exmem_rs2_i       (ex2exmem_rs2_o       ),
        .exmem2mem_wb_en_o    (exmem2mem_wb_en_o    ),
        .exmem2mem_we_o       (exmem2mem_we_o       ),
        .exmem2mem_data_o     (exmem2mem_data_o     ),
        .exmem2mem_mem_addr_o (exmem2mem_mem_addr_o ),
        .exmem2mem_opcode_o   (exmem2mem_opcode_o   ),
        .exmem2mem_funct3_o   (exmem2mem_funct3_o   ),
        .exmem2mem_rd_o       (exmem2mem_rd_o       ),
        .exmem2mem_rs1_o      (exmem2mem_rs1_o      ),
        .exmem2mem_rs2_o      (exmem2mem_rs2_o      )
    );

    // MEM
    wire mem2regs_wb_en_o;
    wire[`RISCV_RD] mem2regs_rd_o;
    wire[`WORD_DATA] mem2regs_rd_data_o;

    MEMU u_MEMU(
        .exmem2mem_wb_en_i    (exmem2mem_wb_en_o   ),
        .exmem2mem_we_i       (exmem2mem_we_o      ),
        .exmem2mem_data_i     (exmem2mem_data_o    ),
        .exmem2mem_mem_addr_i (exmem2mem_mem_addr_o),
        .exmem2mem_opcode_i   (exmem2mem_opcode_o  ),
        .exmem2mem_funct3_i   (exmem2mem_funct3_o  ),
        .exmem2mem_rd_i       (exmem2mem_rd_o      ),
        .exmem2mem_rs1_i      (exmem2mem_rs1_o     ),
        .exmem2mem_rs2_i      (exmem2mem_rs2_o     ),
        .mem2regs_wb_en_o     (mem2regs_wb_en_o    ),
        .mem2regs_rd_o        (mem2regs_rd_o       ),
        .mem2regs_rd_data_o   (mem2regs_rd_data_o  ),
        // 总线
        .bus_mem_req          (bus_m0_req          ),
        .bus_mem_addr         (bus_m0_addr         ),
        .bus_mem_as           (bus_m0_as           ),
        .bus_mem_rw           (bus_m0_rw           ),
        .bus_mem_wr_data      (bus_m0_wr_data      ),
        .bus_mem_grnt         (bus_m0_grnt         ),
        .bus_mem_rdy          (bus_rdy             )
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
        .ex2regs_rd_data_i  (ex2regs_rd_data_o  ),
        .ex2regs_wb_en_i    (ex2regs_wb_en_o    ),
        .mem2regs_wb_en_i   (mem2regs_wb_en_o   ),
        .mem2regs_rd_i      (mem2regs_rd_o      ),
        .mem2regs_rd_data_i (mem2regs_rd_data_o )
    );
    
    //CU
    wire cu2_refresh_flag_o;
    wire cu2pc_jump_en_o;
    wire cu2ex_wb_en_o;
    wire cu2ex_mem_en_o;

    CU u_CU(
        .clk                (clk                ),
        .rest               (rest               ),
        .ex2cu_jump_en_i    (ex2cu_jump_en_o    ),
        .cu2_refresh_flag_o (cu2_refresh_flag_o ),
        .cu2pc_jump_en_o    (cu2pc_jump_en_o    ),
        .id2cu_wb_en_i      (id2cu_wb_en_o      ),
        .id2cu_mem_en_i     (id2cu_mem_en_o     ),
        .cu2ex_wb_en_o      (cu2ex_wb_en_o      ),
        .cu2ex_mem_en_o     (cu2ex_mem_en_o     )
    );
    
    
endmodule
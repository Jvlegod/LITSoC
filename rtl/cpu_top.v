`include "global.v"

module cpu_top(
    input wire clk,
    input wire rest
);
    wire [`WORD_ADDR] if2rom_ins_o;
    wire [`WORD_ADDR] rom2if_ins_o;

    cpu_core u_cpu_core(
        .clk          (clk          ),
        .rest         (rest         ),
        .rom2if_ins_i (rom2if_ins_o ),
        .if2rom_ins_o (if2rom_ins_o )
    );
    
    // bus u_bus(
    //     .clk            (clk            ),
    //     .rest           (rest           ),
    //     .bus_s_addr     (bus_s_addr     ),
    //     .bus_s_as_      (bus_s_as_      ),
    //     .bus_s_rw       (bus_s_rw       ),
    //     .bus_m0_req     (bus_m0_req     ),
    //     .bus_m0_addr    (bus_m0_addr    ),
    //     .bus_m0_as      (bus_m0_as      ),
    //     .bus_m0_rw      (bus_m0_rw      ),
    //     .bus_m0_wr_data (bus_m0_wr_data ),
    //     .bus_m0_grnt    (bus_m0_grnt    ),
    //     .bus_m1_req     (bus_m1_req     ),
    //     .bus_m1_addr    (bus_m1_addr    ),
    //     .bus_m1_as      (bus_m1_as      ),
    //     .bus_m1_rw      (bus_m1_rw      ),
    //     .bus_m1_wr_data (bus_m1_wr_data ),
    //     .bus_m1_grnt    (bus_m1_grnt    ),
    //     .bus_m2_req     (bus_m2_req     ),
    //     .bus_m2_addr    (bus_m2_addr    ),
    //     .bus_m2_as      (bus_m2_as      ),
    //     .bus_m2_rw      (bus_m2_rw      ),
    //     .bus_m2_wr_data (bus_m2_wr_data ),
    //     .bus_m2_grnt    (bus_m2_grnt    ),
    //     .bus_m3_req     (bus_m3_req     ),
    //     .bus_m3_addr    (bus_m3_addr    ),
    //     .bus_m3_as      (bus_m3_as      ),
    //     .bus_m3_rw      (bus_m3_rw      ),
    //     .bus_m3_wr_data (bus_m3_wr_data ),
    //     .bus_rdy        (bus_rdy        ),
    //     .bus_rd_data    (bus_rd_data    ),
    //     .bus_s0_cs      (bus_s0_cs      ),
    //     .bus_s0_rd_data (bus_s0_rd_data ),
    //     .bus_s0_rdy     (bus_s0_rdy     ),
    //     .bus_s1_cs      (bus_s1_cs      ),
    //     .bus_s1_rd_data (bus_s1_rd_data ),
    //     .bus_s1_rdy     (bus_s1_rdy     ),
    //     .bus_s2_cs      (bus_s2_cs      ),
    //     .bus_s2_rd_data (bus_s2_rd_data ),
    //     .bus_s2_rdy     (bus_s2_rdy     ),
    //     .bus_s3_cs      (bus_s3_cs      ),
    //     .bus_s3_rd_data (bus_s3_rd_data ),
    //     .bus_s3_rdy     (bus_s3_rdy     ),
    //     .bus_s4_cs      (bus_s4_cs      ),
    //     .bus_s4_rdy     (bus_s4_rdy     ),
    //     .bus_s4_rd_data (bus_s4_rd_data ),
    //     .bus_s5_cs      (bus_s5_cs      ),
    //     .bus_s5_rdy     (bus_s5_rdy     ),
    //     .bus_s5_rd_data (bus_s5_rd_data ),
    //     .bus_s6_cs      (bus_s6_cs      ),
    //     .bus_s6_rdy     (bus_s6_rdy     ),
    //     .bus_s6_rd_data (bus_s6_rd_data ),
    //     .bus_s7_cs      (bus_s7_cs      ),
    //     .bus_s7_rdy     (bus_s7_rdy     ),
    //     .bus_s7_rd_data (bus_s7_rd_data )
    // );
    

    ins_rom u_ins_rom(
        .if2rom_ins_i (if2rom_ins_o ),
        .rom2if_ins_o (rom2if_ins_o )
    );
    

endmodule
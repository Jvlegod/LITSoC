`include "global.v"

module cpu_top(
    input wire clk,
    input wire rest,
);
    wire [`WORD_ADDR] if2rom_ins_o;
    wire [`WORD_ADDR] rom2if_ins_o;

    cpu_core u_cpu_core(
        .clk          (clk          ),
        .rest         (rest         ),
        .rom2if_ins_i (rom2if_ins_o ),
        .if2rom_ins_o (if2rom_ins_o )
    );          

    wire[`BUS_SLAVE_ADDR] bus_s_addr;
    wire bus_s_as;    
    wire bus_s_rw;      
    wire[`WORD_DATA] bus_s_wr_data;

    // wire bus_m0_req;     
    // wire[`BUS_SLAVE_ADDR] bus_m0_addr;    
    // wire bus_m0_as;      
    // wire bus_m0_rw;      
    // wire[`WORD_DATA] bus_m0_wr_data; 
    wire bus_m0_grnt;    // 此信号给主设备
    
    wire bus_m1_req;    
    wire[`BUS_SLAVE_ADDR] bus_m1_addr;    
    wire bus_m1_as;      
    wire bus_m1_rw;      
    wire[`WORD_DATA] bus_m1_wr_data; 
    wire bus_m1_grnt;    
    
    wire bus_m2_req;     
    wire[`BUS_SLAVE_ADDR] bus_m2_addr;    
    wire bus_m2_as;      
    wire bus_m2_rw;      
    wire[`WORD_DATA] bus_m2_wr_data; 
    wire bus_m2_grnt;    
    
    wire bus_m3_req;     
    wire[`BUS_SLAVE_ADDR] bus_m3_addr;    
    wire bus_m3_as;      
    wire bus_m3_rw;      
    wire[`WORD_DATA] bus_m3_wr_data; 
    wire bus_m2_grnt;    
    
    wire bus_rdy;        
    wire[`WORD_DATA] bus_rd_data;    
    
    wire bus_s0_cs;      
    // wire[`WORD_DATA] bus_s0_rd_data; 
    // wire bus_s0_rdy;     
    
    wire bus_s1_cs;      
    wire[`WORD_DATA] bus_s1_rd_data; 
    wire bus_s1_rdy;     
    
    wire bus_s2_cs;      
    wire[`WORD_DATA] bus_s2_rd_data; 
    wire bus_s2_rdy;     
    
    wire bus_s3_cs;      
    wire[`WORD_DATA] bus_s3_rd_data; 
    wire bus_s3_rdy;     
    
    wire bus_s4_cs;      
    wire[`WORD_DATA] bus_s4_rd_data; 
    wire bus_s4_rdy;     
    
    wire bus_s5_cs;      
    wire[`WORD_DATA] bus_s5_rd_data; 
    wire bus_s5_rdy;     
    
    wire bus_s6_cs;      
    wire[`WORD_DATA] bus_s6_rd_data; 
    wire bus_s6_rdy;     
    
    wire bus_s7_cs;     
    wire[`WORD_DATA] bus_s7_rd_data; 
    wire bus_s7_rdy;     
    
    // MEM
    wire bus_mem_req;
    wire[`WORD_ADDR] bus_mem_addr;
    wire bus_mem_as;
    wire bus_mem_rw;
    wire[`WORD_DATA] bus_mem_wr_data;


    bus u_bus(
        .clk            (clk            ),
        .rest           (rest           ),
        .bus_s_addr     (bus_s_addr     ), // output
        .bus_s_as       (bus_s_as       ), // output
        .bus_s_rw       (bus_s_rw       ), // output
        .bus_s_wr_data  (bus_s_wr_data  ), // output
        // MEM
        .bus_m0_req     (bus_mem_req    ),
        .bus_m0_addr    (bus_mem_addr   ),
        .bus_m0_as      (bus_mem_as     ),
        .bus_m0_rw      (bus_m0_rw      ),
        .bus_m0_wr_data (bus_mem_wr_data),
        .bus_m0_grnt    (bus_m0_grnt    ),
        .bus_m1_req     (bus_m1_req     ),
        .bus_m1_addr    (bus_m1_addr    ),
        .bus_m1_as      (bus_m1_as      ),
        .bus_m1_rw      (bus_m1_rw      ),
        .bus_m1_wr_data (bus_m1_wr_data ),
        .bus_m1_grnt    (bus_m1_grnt    ),
        .bus_m2_req     (bus_m2_req     ),
        .bus_m2_addr    (bus_m2_addr    ),
        .bus_m2_as      (bus_m2_as      ),
        .bus_m2_rw      (bus_m2_rw      ),
        .bus_m2_wr_data (bus_m2_wr_data ),
        .bus_m2_grnt    (bus_m2_grnt    ),
        .bus_m3_req     (bus_m3_req     ),
        .bus_m3_addr    (bus_m3_addr    ),
        .bus_m3_as      (bus_m3_as      ),
        .bus_m3_rw      (bus_m3_rw      ),
        .bus_m3_wr_data (bus_m3_wr_data ),
        .bus_rdy        (bus_rdy        ), // output
        .bus_rd_data    (bus_rd_data    ), // output
        // 定时器
        .bus_s0_cs      (bus_s0_cs      ),
        .bus_s0_rd_data (Timer_rd_data  ),
        .bus_s0_rdy     (Timer_rdy      ),
        .bus_s1_cs      (bus_s1_cs      ),
        .bus_s1_rd_data (bus_s1_rd_data ),
        .bus_s1_rdy     (bus_s1_rdy     ),
        .bus_s2_cs      (bus_s2_cs      ),
        .bus_s2_rd_data (bus_s2_rd_data ),
        .bus_s2_rdy     (bus_s2_rdy     ),
        .bus_s3_cs      (bus_s3_cs      ),
        .bus_s3_rd_data (bus_s3_rd_data ),
        .bus_s3_rdy     (bus_s3_rdy     ),
        .bus_s4_cs      (bus_s4_cs      ),
        .bus_s4_rdy     (bus_s4_rdy     ),
        .bus_s4_rd_data (bus_s4_rd_data ),
        .bus_s5_cs      (bus_s5_cs      ),
        .bus_s5_rdy     (bus_s5_rdy     ),
        .bus_s5_rd_data (bus_s5_rd_data ),
        .bus_s6_cs      (bus_s6_cs      ),
        .bus_s6_rdy     (bus_s6_rdy     ),
        .bus_s6_rd_data (bus_s6_rd_data ),
        .bus_s7_cs      (bus_s7_cs      ),
        .bus_s7_rdy     (bus_s7_rdy     ),
        .bus_s7_rd_data (bus_s7_rd_data )
    );

    wire Timer_rdy;
    wire[`WORD_DATA] Timer_rd_data;

    Timer u_Timer(
        .clk           (clk           ),
        .rest          (rest          ),
        .Timer_cs      (bus_s0_cs     ),
        .Timer_as      (bus_s_as      ), // 选通
        .Timer_rw      (bus_s_rw      ), // 读写位
        .Timer_rdy     (Timer_rdy     ),
        .Timer_addr    (bus_s_addr    ),
        .Timer_wr_data (bus_s_wr_data ),
        .Timer_rd_data (Timer_rd_data ),
        .Timer_irq     (Timer_irq     ) // 暂不支持中断
    );
    
    

    ins_rom u_ins_rom(
        .if2rom_ins_i (if2rom_ins_o ),
        .rom2if_ins_o (rom2if_ins_o )
    );
    
    

endmodule
`include "global.v"

module bus(
    input wire clk,
    input wire rest,


    // 中间
    output wire[`BUS_SLAVE_ADDR] bus_s_addr,        // 选择出的从属信号的地址
    output wire				     bus_s_as,	 
	output wire				     bus_s_rw,
    output wire[`WORD_DATA]      bus_s_wr_data,     // 主控写入的数据，送给从设备接收*

    // 主控
    input wire                  bus_m0_req,         // 请求信号
    input wire[`BUS_SLAVE_ADDR] bus_m0_addr,        // 选择的从属设备
    input wire                  bus_m0_as,          // 选通信号
    input wire                  bus_m0_rw,          // 读写信号
    input wire[`WORD_DATA]      bus_m0_wr_data,     // 读/写的数据
    output wire                 bus_m0_grnt,        // 赋予信号

    input wire                  bus_m1_req,
    input wire[`BUS_SLAVE_ADDR] bus_m1_addr,
    input wire                  bus_m1_as,
    input wire                  bus_m1_rw,
    input wire[`WORD_DATA]      bus_m1_wr_data,
    output wire                 bus_m1_grnt,

    input wire                  bus_m2_req,
    input wire[`BUS_SLAVE_ADDR] bus_m2_addr,
    input wire                  bus_m2_as,
    input wire                  bus_m2_rw,
    input wire[`WORD_DATA]      bus_m2_wr_data,
    output wire                 bus_m2_grnt,

    input wire                  bus_m3_req,
    input wire[`BUS_SLAVE_ADDR] bus_m3_addr,
    input wire                  bus_m3_as,
    input wire                  bus_m3_rw,
    input wire[`WORD_DATA]      bus_m3_wr_data,
    output wire                 bus_m3_grnt,

    // 从属
    output wire bus_rdy,                  // 从属就绪信号
    output wire[`WORD_DATA] bus_rd_data,  // 从属读出的数据，主设备接收

    output  wire bus_s0_cs,                // s0从属片选信号
    input  wire[`WORD_DATA] bus_s0_rd_data,            // s0从属读出的数据
    input wire bus_s0_rdy,                 // s0从属就绪信号

    output  wire bus_s1_cs,
    input  wire[`WORD_DATA] bus_s1_rd_data,
    input  wire bus_s1_rdy,

    output wire bus_s2_cs,
    input  wire[`WORD_DATA] bus_s2_rd_data,
    input wire bus_s2_rdy,

    output wire bus_s3_cs,
    input  wire[`WORD_DATA] bus_s3_rd_data,
    input wire bus_s3_rdy,

    output wire bus_s4_cs,
    input  wire[`WORD_DATA] bus_s4_rd_data,
    input  wire bus_s4_rdy,

    output wire bus_s5_cs,
    input  wire[`WORD_DATA] bus_s5_rd_data,
    input  wire bus_s5_rdy,

    output wire bus_s6_cs,
    input  wire[`WORD_DATA] bus_s6_rd_data,
    input  wire bus_s6_rdy,

    output wire bus_s7_cs,
    input  wire[`WORD_DATA] bus_s7_rd_data
    input  wire bus_s7_rdy,
);
    bus_arbiter u_bus_arbiter(
        .clk     (clk         ),
        .rest    (rest        ),
        .m0_req  (bus_m0_req  ),
        .m0_grnt (bus_m0_grnt ),
        .m1_req  (bus_m1_req  ),
        .m1_grnt (bus_m1_grnt ),
        .m2_req  (bus_m2_req  ),
        .m2_grnt (bus_m2_grnt ),
        .m3_req  (bus_m3_req  ),
        .m3_grnt (bus_m3_grnt )
    );
    
    bus_master_mux u_bus_master_mux(
        .m0_addr    (bus_m0_addr    ),
        .m0_as      (bus_m0_as      ),
        .m0_rw      (bus_m0_rw      ),
        .m0_wr_data (bus_m0_wr_data ),
        .m0_grnt    (bus_m0_grnt    ),
        .m1_addr    (bus_m1_addr    ),
        .m1_as      (bus_m1_as      ),
        .m1_rw      (bus_m1_rw      ),
        .m1_wr_data (bus_m1_wr_data ),
        .m1_grnt    (bus_m1_grnt    ),
        .m2_addr    (bus_m2_addr    ),
        .m2_as      (bus_m2_as      ),
        .m2_rw      (bus_m2_rw      ),
        .m2_wr_data (bus_m2_wr_data ),
        .m2_grnt    (bus_m2_grnt    ),
        .m3_addr    (bus_m3_addr    ),
        .m3_as      (bus_m3_as      ),
        .m3_rw      (bus_m3_rw      ),
        .m3_wr_data (bus_m3_wr_data ),
        .m3_grnt    (bus_m3_grnt    ),
        .s_addr     (bus_s_addr     ),
        .s_as       (bus_s_as       ),
        .s_rw       (bus_s_rw       ),
        .s_wr_data  (bus_s_wr_data  )
    );
    
    bus_addr_dec u_bus_addr_dec(
        .s_addr     (bus_s_addr ),
        .s_wr_data  (bus_wr_data),
        .s0_cs      (bus_s0_cs  ),
        .s1_cs      (bus_s1_cs  ),
        .s2_cs      (bus_s2_cs  ),
        .s3_cs      (bus_s3_cs  ),
        .s4_cs      (bus_s4_cs  ),
        .s5_cs      (bus_s5_cs  ),
        .s6_cs      (bus_s6_cs  ),
        .s7_cs      (bus_s7_cs  )
    );
    
    bus_slave_mux u_bus_slave_mux(
        .s0_cs       (bus_s0_cs     ),
        .s0_rd_data  (bus_s0_rd_data),
        .s0_rdy      (bus_s0_rdy    ),
        .s1_cs       (bus_s1_cs     ),
        .s1_rd_data  (bus_s1_rd_data),
        .s1_rdy      (bus_s1_rdy    ),
        .s2_cs       (bus_s2_cs     ),
        .s2_rd_data  (bus_s2_rd_data),
        .s2_rdy      (bus_s2_rdy    ),
        .s3_cs       (bus_s3_cs     ),
        .s3_rd_data  (bus_s3_rd_data),
        .s3_rdy      (bus_s3_rdy    ),
        .s4_cs       (bus_s4_cs     ),
        .s4_rd_data  (bus_s4_rd_data),
        .s4_rdy      (bus_s4_rdy    ),
        .s5_cs       (bus_s5_cs     ),
        .s5_rd_data  (bus_s5_rd_data),
        .s5_rdy      (bus_s5_rdy    ),
        .s6_cs       (bus_s6_cs     ),
        .s6_rd_data  (bus_s6_rd_data),
        .s6_rdy      (bus_s6_rdy    ),
        .s7_cs       (bus_s7_cs     ),
        .s7_rd_data  (bus_s7_rd_data),
        .s7_rdy      (bus_s7_rdy    ),
        .bus_rd_data (bus_rd_data   ), // 读出从属设备的数据，送给主设备接收*
        .bus_rdy     (bus_rdy       )  // 读出就绪置位
    );
    

endmodule
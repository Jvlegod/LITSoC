`include "global.v"

module data_ram(
    // from MEM
    input wire[`WORD_ADDR] mem2ram_addr, // 地址
    // to MEM
    output reg[`WORD_DATA] ram2mem_data // 地址
);
    reg[`WORD_DATA] data_mem[0:4095]; // 内存

    always @(*) begin
        ram2mem_data = data_mem[mem2ram_addr];
    end

endmodule



// 挂总线的版本
// module data_ram(
//     // from bus
//     input wire[`WORD_DATA] bus_s_wr_data,
//     input wire cs, // 片选
//     input wire as, // 选通
//     input wire[`WORD_ADDR] addr, // 地址
//     // to bus
//     output wire[`WORD_DATA] data, // 数据
//     output reg rdy // 就绪
// );
// endmodule
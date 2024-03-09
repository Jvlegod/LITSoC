`include "global.v"

module data_ram(
    // from MEM
    input wire mem2ram_we, // 写使能
    input wire[`WORD_ADDR] mem2ram_addr, // 地址
    input wire[`WORD_DATA] mem2ram_data, // 数据
    // input wire[`WORD_DATA] ex2mem_passbynetwork_rd_i,
    // to MEM
    output reg[`WORD_DATA] ram2mem_data, // 地址
    // output reg[`WORD_DATA] mem2regs_passbynetwork_o
    // to Bus
    output reg[`WORD_ADDR] bus_mem_addr, // 地址
    output reg[`WORD_DATA] bus_mem_data // 数据
);
    reg[`BYTE] data_mem[0:3][0:4095]; // 内存

    always @(*) begin // 读
        if (mem2ram_we == `DISABLE) begin
            ram2mem_data = {data_mem[3][mem2ram_addr], data_mem[2][mem2ram_addr], data_mem[1][mem2ram_addr], data_mem[0][mem2ram_addr]};
            // ram2mem_data = data_mem[mem2ram_addr];
        end
    end

    always @(*) begin // 写
        if (mem2ram_we == `ENABLE) begin
            data_mem[0][mem2ram_addr] = mem2ram_data[7:0];
            data_mem[1][mem2ram_addr] = mem2ram_data[15:8];
            data_mem[2][mem2ram_addr] = mem2ram_data[23:16];
            data_mem[3][mem2ram_addr] = mem2ram_data[31:24];
            // to bus
            bus_mem_addr = mem2ram_addr;
            bus_mem_data = mem2ram_data;
            // data_mem[mem2ram_addr] = mem2ram_data;
            // for (i = 0; i < 4; i ++) begin
            //     data_mem[i][mem2ram_addr] = mem2ram_data[(i+1)*8-1:i*8];
            // end
        end 
    end
    
    // always @(*) begin
    //     mem2regs_passbynetwork_o = ex2mem_passbynetwork_rd_i;
    // end
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

// 老版本RAM
// module data_ram(
//     // from MEM
//     input wire mem2ram_we, // 写使能
//     input wire[`WORD_ADDR] mem2ram_addr, // 地址
//     input wire[`WORD_DATA] mem2ram_data, // 数据
//     // to MEM
//     output reg[`WORD_DATA] ram2mem_data // 地址
// );
//     integer i;
//     reg[`WORD_DATA] data_mem_l[7:0];  // 内存(低字字节)
//     reg[`WORD_DATA] data_mem_ml[7:0]; // 内存(低中字节)
//     reg[`WORD_DATA] data_mem_mh[7:0]; // 内存(高中字节)
//     reg[`WORD_DATA] data_mem_h[7:0];  // 内存(高字字节)

//     always @(*) begin // 读
//         if (mem2ram_we == `DISABLE) begin
//             ram2mem_data[7:0] = data_mem_l[mem2ram_addr[7:0]];
//             ram2mem_data[15:8] = data_mem_ml[mem2ram_addr[15:8]];
//             ram2mem_data[23:16] = data_mem_mh[mem2ram_addr[23:16]];
//             ram2mem_data[31:24] = data_mem_h[mem2ram_addr[31:24]];
//         end
//     end

//     always @(*) begin // 写
//         if (mem2ram_we == `ENABLE) begin
//             data_mem_l[mem2ram_addr[7:0]] = mem2ram_data[7:0];
//             data_mem_ml[mem2ram_addr[15:8]] = mem2ram_data[15:8];
//             data_mem_mh[mem2ram_addr[23:16]] = mem2ram_data[23:16];
//             data_mem_h[mem2ram_addr[31:24]] = mem2ram_data[31:24];
//         end 
//     end

// endmodule
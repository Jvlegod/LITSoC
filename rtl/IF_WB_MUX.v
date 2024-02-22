// `include "global.v"

// module IF_WB_MUX(
//     // from EX
//     input wire exif_wb_en_i,
//     input wire exif_mem_en_i,
//     input reg[`REGS_ADDR] ex2mux_rd_addr_i,
//     input reg[`WORD_DATA] ex2mux_rd_data_i,
//     // to regs
//     output reg[`REGS_ADDR] ex2regs_rd_addr_o,
//     output reg[`WORD_DATA] ex2regs_rd_data_o
// );

//     always @(*) begin
//         if ((exif_wb_en_i == `ENABLE) && (exif_mem_en_i == `ENABLE)) begin
//             ex2regs_rd_addr_o = `DEFAULT_5_ZERO;
//             ex2regs_rd_data_o = `DEFAULT_32_ZERO;
//         end else if ((exif_wb_en_i == `ENABLE) && (exif_mem_en_i == `DISABLE)) begin
//             ex2regs_rd_addr_o = ex2mux_rd_addr_i;
//             ex2regs_rd_data_o = ex2mux_rd_data_i;
//         end else if ((exif_wb_en_i == `DISABLE) && (exif_mem_en_i == `ENABLE)) begin
//             ex2regs_rd_addr_o = `DEFAULT_5_ZERO;
//             ex2regs_rd_data_o = `DEFAULT_32_ZERO;
//         end else if ((exif_wb_en_i == `DISABLE) && (exif_mem_en_i == `DISABLE)) begin
//             ex2regs_rd_addr_o = `DEFAULT_5_ZERO;
//             ex2regs_rd_data_o = `DEFAULT_32_ZERO;
//         end
//     end
// endmodule
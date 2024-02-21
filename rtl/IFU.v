`include "global.v"

module IFU(
    // from pc
    input wire[`WORD_ADDR] pc2if_addr_i,
    // from rom
    input wire[`WORD_ADDR] rom2if_ins_i,
    // to rom
    output wire[`WORD_ADDR] if2rom_ins_o,
    // to IF/ID
    output wire[`WORD_ADDR] if2ifid_addr_o,
    output wire[`WORD_ADDR] if2ifid_ins_o
);

    assign if2rom_ins_o = pc2if_addr_i;
    assign if2ifid_ins_o = rom2if_ins_i;
    assign if2ifid_addr_o = pc2if_addr_i;

endmodule
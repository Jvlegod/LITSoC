`include "global.v"

module ins_rom(
    // from if
    input wire[`WORD_ADDR] if2rom_ins_i,
    // to if
    output wire[`WORD_ADDR] rom2if_ins_o
);
    // 存储指令
    reg[`WORD_DATA] rom_mem[0:4095];

    assign rom2if_ins_o = rom_mem[if2rom_ins_i>>2];

endmodule
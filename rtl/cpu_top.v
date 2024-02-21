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
    
    ins_rom u_ins_rom(
        .if2rom_ins_i (if2rom_ins_o ),
        .rom2if_ins_o (rom2if_ins_o )
    );
    

endmodule
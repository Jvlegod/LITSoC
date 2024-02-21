`include "global.v"

module PC(
    input wire clk,
    input wire rest,

    // input wire pc_addr_i, // PC输入地址
    // input wire jump_en,
    // to IF
    output reg[`WORD_ADDR] pc2if_addr_o, // PC值 
    // from CU
    input wire cu2pc_jump_en_i,
    // from EX
    input wire[`WORD_ADDR] ex2pc_jump_addr_i
);

    always @(posedge clk) begin
        if (rest == `RESET) begin
            pc2if_addr_o <= `DEFAULT_32_ZERO;
        end else if (cu2pc_jump_en_i == `ENABLE) begin
            pc2if_addr_o <= ex2pc_jump_addr_i;
        end else begin
            pc2if_addr_o <= pc2if_addr_o + `A_PC;
        end
    end

endmodule
`include "global.v"

module DFF #(
    parameter WD = 32
)(
    input wire clk,
    input wire rest,
    input wire[WD-1:0] default_rest,
    input wire[WD-1:0] D,
    output reg[WD-1:0] Q,
    input wire dff_refresh_flag_i
);
    always@(posedge clk) begin
        if ((rest == `RESET) || (dff_refresh_flag_i == `ENABLE)) begin
            Q <= default_rest;
        end else begin
            Q <= D;
        end
    end
 endmodule

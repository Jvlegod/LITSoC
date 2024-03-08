`timescale 1ns/1ns
`include "global.v"

module module_tb;

    reg clk;
    reg rest;
    reg cs;
    reg as;
    reg rw;
    wire rdy;
    reg[2:0] addr;
    reg[`WORD_DATA] wr_data;
    wire[`WORD_DATA] rd_data;
    wire irq;

    initial begin
        clk = 0;
		rest <= 1'b0;
		#10;
		rest <= 1'b1;
        #10;
        cs <= `ENABLE;
        as <= `ENABLE;
        rw <= `WRITE;
        addr <= `TIMER_CTRL_ADDR;
        wr_data <= `TIMER_CIRCLE_UP;
        #3000;
        wr_data <= `TIMER_MODE_CIRCLE_DOWN;
        #500
        wr_data <= `TIMER_STOP;
    end

    always #10 clk = ~clk;

    initial begin
        forever begin
			@(posedge clk) 
			$display("counter register value is %d",module_tb.u_Timer.counter);
			$display("expr_val register value is %d",module_tb.u_Timer.expr_val);
			$display("expr_flag register value is %d",module_tb.u_Timer.expr_flag);
			$display("---------------------------");
			$display("---------------------------");
		end
    end

    initial begin
        $dumpfile("./generated/module_tb.vcd");
        $dumpvars(0, module_tb);
    end

    initial begin
        #20000;
        $finish;
    end

    Timer u_Timer(
        .clk           (clk     ),
        .rest          (rest    ),
        .Timer_cs      (cs      ),
        .Timer_as      (as      ),
        .Timer_rw      (rw      ),
        .Timer_rdy     (rdy     ),
        .Timer_addr    (addr    ),
        .Timer_wr_data (wr_data ),
        .Timer_rd_data (rd_data ),
        .Timer_irq     (irq     )
    );
endmodule
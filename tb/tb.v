`timescale 1ns/1ns
`include "global.v"

module tb;

    reg clk;
    reg rest;

    integer i;
    wire x3 = tb.u_cpu_top.u_cpu_core.u_regs.x_regs[3];
	wire x26 = tb.u_cpu_top.u_cpu_core.u_regs.x_regs[26];
	wire x27 = tb.u_cpu_top.u_cpu_core.u_regs.x_regs[27];

    initial begin
        clk = 0;
		rest <= 1'b0;
		#10;
		rest <= 1'b1;
    end

    always #10 clk = ~clk;

    initial begin
        $readmemb("./self_tests/MEM.txt", tb.u_cpu_top.u_ins_rom.rom_mem);
        // $readmemb("./self_tests/BEQ.txt", tb.u_cpu_top.u_ins_rom.rom_mem);
        // $readmemh("./tests/rv32ui-p-bne.txt", tb.u_cpu_top.u_ins_rom.rom_mem);
    end

    initial begin
        while(1)begin
			@(posedge clk) 
			$display("PC register value is %d",tb.u_cpu_top.u_cpu_core.u_pc_reg.pc2if_addr_o);
			$display("x3 register value is %d",tb.u_cpu_top.u_cpu_core.u_regs.x_regs[3]);
			$display("x4 register value is %d",tb.u_cpu_top.u_cpu_core.u_regs.x_regs[4]);
			$display("x5 register value is %d",tb.u_cpu_top.u_cpu_core.u_regs.x_regs[5]);
			$display("---------------------------");
			$display("---------------------------");
		end
    end

    // initial begin
	// 	wait(x26 == 32'b1);
		
	// 	#200;
	// 	if(x27 == 32'b1) begin
	// 		$display("############################");
	// 		$display("########  pass  !!!#########");
	// 		$display("############################");
	// 	end
	// 	else begin
	// 		$display("############################");
	// 		$display("########  fail  !!!#########");
	// 		$display("############################");
	// 		$display("fail testnum = %2d", x3);
	// 		for(i = 0;i < 31; i = i + 1)begin
	// 			$display("x%2d register value is %d",i,tb.u_cpu_top.u_cpu_core.u_regs.x_regs[i]);	
	// 		end	
	// 	end
	// end

    initial begin
        $dumpfile("./generated/tb.vcd");
        $dumpvars(0, tb);
    end

    initial begin
        #1000;
        $finish;
    end

    cpu_top u_cpu_top(
        .clk  (clk  ),
        .rest (rest )
    );
    
    
    

endmodule
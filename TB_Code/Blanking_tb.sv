//
`timescale 1ns/1ps

module Blanking_tb();
	logic [3:0] in0, in1, in2, in3, in4, in5;
   logic [5:0] DP_in;
   logic [5:0] Blank;

	// instantiate UUTs
	Blanking UUT (.*); 


	// apply stimulus
	initial begin 
		$display("---  Testbench started  ---");
		DP_in = 6'b00_0000; in0 = 6'b00_0000; in1 = 6'b00_0000; in2 = 6'b00_0000; in3 = 6'b00_0000; in4 = 6'b00_0000; in5 = 6'b00_0000; #30;
		assert (Blank[0] === 1) else $error("init failed.");
		in0 = 6'b00_0001; #30;
		assert (Blank[0] != 1) else $error("in0 failed.");
		in1 = 6'b00_0001; #30;
		assert (Blank[1] != 1) else $error("in1 failed.");
		in2 = 6'b00_0001; #30;
		assert (Blank[2] != 1) else $error("in2 failed.");
		in3 = 6'b00_0001; #30;
		assert (Blank[3] != 1) else $error("in3 failed.");
		in4 = 6'b00_0001; #30;
		assert (Blank[4] != 1) else $error("in4 failed.");
		in5 = 6'b00_0001; #30;
		assert (Blank[5] != 1) else $error("in5 failed.");
		$display("\n===  Testbench ended  ===");
		$stop; // this stops simulation, needed because clk runs forever
	end


endmodule

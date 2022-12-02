//
`timescale 1ns/1ns

module Linearizer_tb();
	parameter width = 12;
	parameter precision = 8;
	
	logic                   mode_close;
	logic [12:0] 		in;
	logic [12:0]   cmS, cmF;
	logic [12:0]   result;
	logic [25:0]   mult, sub, shift;
	logic [4:0] trunc;
	
	logic [20:0] errors;
	
	// instantiate UUTs
	Linearizer #(width, precision) UUT (.*); 
	
	initial begin
		$monitor(,$time,": in=%d,result=%dmode=%b",in,result,mode_close);
	end
	
	initial begin 
		$display("---  Testbench started  ---");
		errors = 0;
		in = 0; mode_close = 1;
		for (in = 0; in < 3584; in += 1) begin
			#10;
		end
		in = 0; #10;
		mode_close = 0; #10;
		for (in = 0; in < 3584; in += 1) begin
			#10;
		end
		
		//if (errors == 0) $display("\nAll Clear!");
		//else $display("\n %d Errors", errors);
		$display("\n===  Testbench ended  ===");
		$stop; // this stops simulation, needed because clk runs forever
	end


endmodule

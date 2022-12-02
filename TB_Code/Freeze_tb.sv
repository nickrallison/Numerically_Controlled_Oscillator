//
`timescale 100ns/1ns

module Freeze_tb();
	parameter width = 8;
	
	time clock_period = 1000ns;
	
	logic               reset_n = 1;
	logic               clk = 0;
	logic               s = 1;
	logic [width - 1:0] in = 8'b1111_1111;
	logic [width - 1:0] out, inter;

	// instantiate UUTs
	Freeze #(width) UUT (.reset_n(reset_n), .clk(clk), .s(s), .in(in), .inter(inter), .out(out)); 

	always begin //1us clock period
    #5;
    clk = 1;
    #5;
    clk = 0;    
	end
	
	initial begin
		 //$monitor("time=%3d, s=%b in=%d,inter=%d, out=%d \n",$time,s,in,inter,out);
	end
	
	// apply stimulus
	initial begin 
		$display("---  Testbench started  ---");
		#(clock_period/4);
		reset_n = 0; #(2*clock_period);
		reset_n = 1;#(2*clock_period);
		assert (out === in) else $error("Init Failed");
		s = 0; #(2*clock_period);
		assert (out === in) else $error("Freeze Press Failed");
		in = 8'b0000_0000; #(2*clock_period);
		assert (out === 8'b1111_1111) else $error("Freeze Change Failed");
		s = 1; #(2*clock_period);
		assert (out === in) else $error("Freeze Release Failed");
		
		$display("\n===  Testbench ended  ===");
		$stop; // this stops simulation, needed because clk runs forever
	end


endmodule

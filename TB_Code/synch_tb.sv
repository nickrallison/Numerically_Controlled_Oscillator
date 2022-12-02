//
`timescale 1ns/1ps

module synch_tb();
	logic       clk = 0, reset_n;
	logic [9:0] in, out;

	// instantiate UUTs
	synch UUT (.clk(clk), .reset_n(reset_n), .in(in), .out(out)); 
	//binary_bcd_nonblock UUT_nonblock(.*,.bcd(bcd_compare));

	// apply stimulus
	always #(20/2) clk = ~clk; // run clock forever with period 20 ns
	initial begin 
		$display("---  Testbench started  ---");
		in = 10'b00_0000_0000;
		#5;
		reset_n = 1'b1; #20;
		reset_n = 1'b0; #20;
		reset_n = 1'b1; #20;
		assert (out === 10'b00_0000_0000) else $error("Init failed.");
		in = 10'b00_0000_0001;
		assert (out === 10'b00_0000_0000) else $error("Synch Failed Immediately");
		#20;
		assert (out === 10'b00_0000_0000) else $error("Synch Failed at 1 clk");
		#20;
		assert (out === in) else $error("Synch Failed to converge at 2 clk");
		$display("\n===  Testbench ended  ===");
		$stop; // this stops simulation, needed because clk runs forever
	end


endmodule

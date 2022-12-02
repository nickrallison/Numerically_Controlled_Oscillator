//
`timescale 1ns/1ps

module MUX4TO1_tb();
	parameter width = 16;
	logic [2:1]         s;
	logic [width - 1:0] in1, in2, in3, in4, mux_out;

	// instantiate UUTs
	MUX4TO1 UUT (.in1(in1), .in2(in2), .in3(in3), .in4(in4), .s(s), .mux_out(mux_out)); 
	//binary_bcd_nonblock UUT_nonblock(.*,.bcd(bcd_compare));

	// apply stimulus
	initial begin 
		$display("---  Testbench started  ---");
		s = 2'b00; in1 = 16'b0000_0000_0000_0000; in2 = 16'b0000_0000_0000_0001; in3 = 16'b0000_0000_0000_0010; in4 = 16'b0000_0000_0000_0011; #30;
		assert (in1 === mux_out) else $error("s xx -> 00, in1 failed.");
		in1 = 16'b1000_0000_0000_0000; #30;
		assert (in1 === mux_out) else $error("delta in1 failed.");
		s = 2'b01; #30;
		assert (in2 === mux_out) else $error("s 00 -> 01, in2 failed.");
		in2 = 16'b1100_0000_0000_0000; #30;
		assert (in2 === mux_out) else $error("delta in2 failed.");
		s = 2'b10; #30;
		assert (in3 === mux_out) else $error("s 01 -> 10, in3 failed.");
		in3 = 16'b1110_0000_0000_0000; #30;
		assert (in3 === mux_out) else $error("delta in3 failed.");
		s = 2'b11; #30;
		assert (in4 === mux_out) else $error("s 10 -> 11, in4 failed.");
		in4 = 16'b1111_0000_0000_0000; #30;
		assert (in4 === mux_out) else $error("delta in4 failed.");

		$display("\n===  Testbench ended  ===");
		$stop; // this stops simulation, needed because clk runs forever
	end


endmodule

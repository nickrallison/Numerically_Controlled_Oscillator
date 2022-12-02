//
`timescale 1ns/1ps

module top_level_tb();
   parameter width = 32; // Need to choose and have a reason
   parameter decimals = 16; // Need to choose and have a reason
  
   parameter LUT_Size = 8;
   parameter Output_Resolution = 16;
  
	logic        clk = 0;
   logic [1:0]  KEY = 2'b11;
   logic [9:0]  SW = 0;
   logic [9:0]  LEDR;
   logic [7:0]  HEX0,HEX1,HEX2,HEX3,HEX4,HEX5;
   logic [15:0] ARDUINO_IO;
	
	logic [21:0] distance;
   logic        direction_low;
   logic        sign_low;
	logic        direction_high;
   logic        sign_high;
	logic  [Output_Resolution:0]   output_value_low; // add signed
   logic  [Output_Resolution:0]   output_value_high;
	logic  [Output_Resolution:0]   out_unscaled;
   logic  [Output_Resolution-1:0] out;
  
	// instantiate UUTs
	top_level UUT (.*); 
	//binary_bcd_nonblock UUT_nonblock(.*,.bcd(bcd_compare));

	// apply stimulus
	always #(20/2) clk = ~clk; // run clock forever with period 20 ns
	
	initial begin 
		$display("---  Testbench started  ---");
		#5;
		KEY[0] = 0;#10;
		KEY[0] = 1;#10;

		for (int i = 0; i < 50; i++) begin
			SW++; #10000;
		end
		$display("\n===  Testbench ended  ===");
		$stop; // this stops simulation, needed because clk runs forever
	end


endmodule

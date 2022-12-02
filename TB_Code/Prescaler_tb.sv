//
`timescale 1ns/1ns

module Prescaler_tb();
	parameter width = 12;

	logic [width - 1:0] in;
	logic [width:0]     result;
	 
	logic [20:0] errors;
	
	// instantiate UUTs
	Prescaler #(width) UUT (.*); 
	
	initial begin
		//$monitor(,$time,": in=%d,out=%d",in,result);
	end
	
	initial begin 
		$display("---  Testbench started  ---");
		errors = 0;
		in = 0;
		for (in = 0; in < 1600; in += 1) begin
			#10;
			assert (((5000 * in) / 2048) === result) else begin
				$error("in=%d,out=%d failed. out correct=%d ",in,result,((5000 * in) / 2048));
				errors++;
			end
		end
		
		if (errors == 0) $display("\nAll Clear!");
		else $display("\n %d Errors", errors);
		$display("\n===  Testbench ended  ===");
		$stop; // this stops simulation, needed because clk runs forever
	end


endmodule

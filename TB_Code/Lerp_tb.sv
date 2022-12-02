//
`timescale 1ns/1ns

module Lerp_tb();
	parameter width = 12;
	parameter precision = 8;
	
	logic [4:0]  frac;
	logic [12:0] first, second, out;
	logic [25:0] mult, sub, shift;
	
	logic [20:0] errors;
	
	// instantiate UUTs
	Lerp #(width, precision) UUT (.*); 
	
	initial begin 
		$display("---  Testbench started  ---");
		errors = 0;
		inLerp = 0; first = 100; second = 200;
		for (inLerp = 0; inLerp < 2**(4) - 1; inLerp += 1) begin
			#10;
			assert ((((second - first) * frac) >> precision) + first === out) else begin
				$error("in=%d,first=%d,second=%d,shift=%d,sub=%d,mult=%d,out=%d failed. out correct=%d ",inLerp,first,second,shift,sub,mult,out,((second-first)>>precision)*inLerp+first);
				errors++;
			end
		end
		inLerp = 0; first = 200; second = 100;
		for (inLerp = 0; inLerp < 2**(4) - 1; inLerp += 1) begin
			#10;
			assert (-(((first - second) * inLerp) >> precision) + first === out) else begin
				$error("in=%d,first=%d,second=%d,shift=%d,sub=%d,mult=%d,out=%d failed. out correct=%d ",inLerp,first,second,shift,sub,mult,out,((second-first)>>precision)*inLerp+first);
				errors++;
			end
		end
		
		if (errors == 0) $display("\nAll Clear!");
		else $display("\n %d Errors", errors);
		$display("\n===  Testbench ended  ===");
		$stop; // this stops simulation, needed because clk runs forever
	end


endmodule

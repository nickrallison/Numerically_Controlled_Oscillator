module Lerp #(parameter width=32, decimals=16)
(
	input  logic signed [width-1:0]     first, second,
	input  logic [decimals-1:0]  frac,
	output logic signed [width-1:0]     out
);
	logic [2*width-1:0] sub, mult, shift;
	always_comb begin
		if (second > first) sub = second - first;
		else sub = first - second;
		mult = sub * frac;
		shift = mult >> decimals;
		//shift = mult;
		if (second > first) out = first + shift;
		else out = first - shift;
	end
	
	
endmodule
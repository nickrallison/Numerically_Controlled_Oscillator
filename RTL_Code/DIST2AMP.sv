module DIST2AMP #(parameter widthin=16, parameter widthout=26, parameter decimal=20)
  (input  logic [12:0] distance,	// dist
   input logic [15:0] wave, // sin
   output logic [15:0] out
	);
	
	
	logic [21:0] intermediate;
	logic [35:0] intermediate_out;
	logic [15:0] scaling;
	//logic [widthout + widthin -1] unshifted_out;
	
	
	always_comb begin
			intermediate = (9'b1_0110_1001)*(distance - 13'b0_0001_0101_1110);// - 22'd144631; //calculate jump value
			//scaling = intermediate >> 6;
			intermediate_out = wave*intermediate[19:0];
			if (distance > 3300) out = wave;
			else out = intermediate_out[35:20];
	end
      
endmodule

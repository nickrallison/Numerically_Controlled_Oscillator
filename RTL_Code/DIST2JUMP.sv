module DIST2JUMP #(parameter widthin=13, parameter widthout=26, parameter decimal=16)
  (input  logic [widthin-1:0] in,
   output logic [widthout-1:0] out
	);

	logic [18:0] intermediate;
	
	always_comb begin
			intermediate = (((6'h25)*in) >> 2) + 19'h5E1F8; //calculate jump value
			out[18:0] = intermediate;
			out[widthout-1:19] = '0;
	end
      
endmodule
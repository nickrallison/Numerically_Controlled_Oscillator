module DIST2JUMP #(parameter widthin=22, parameter widthout=26, parameter decimal=16)
  (input  logic [widthin-1:0] in,
	input  logic [9:0] SW,
   output logic [widthout-1:0] out,
	output logic [2*widthin-1:0] large_jump,
	input  logic test_mode
	);
  
	//logic test_mode = 1; 

	assign large_jump = 22'b000000_0000_0011_1001_1101*in; // Hard coded to 22,16
	//assign out = large_jump[widthout+decimal-1:decimal] + 26'b00_0000_0101_1110_0001_1111_1000;
  
	always_comb begin
		case (test_mode)
			0: out = large_jump[widthout+decimal-1:decimal] + 26'b00_0000_0101_1110_0001_1111_1000;
			1: out = {4'b0, SW, 12'b0};
		endcase
	end
      
endmodule
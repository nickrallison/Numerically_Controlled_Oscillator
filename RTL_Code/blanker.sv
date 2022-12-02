//

module blanker
 #(parameter n = 6)
  (input  logic [4*n - 1:0] input_signal,
   input  logic [n - 1:0]   DP_in,
   output logic [n - 1:0]	 blanks);
	
	genvar i;
	
	generate
		
		assign blanks[n - 1] = (~|(input_signal[4*n - 1 : 4*(n-1)])) & (~DP_in[n - 1]);
		
		for(i= n - 2; i > 0; i--) begin : blank_loop
		
			assign blanks[i] = (~|(input_signal[4*(i+1) - 1 : 4*i])) & (~DP_in[i]) & (blanks[i+1]);
			
		end
		
	endgenerate

	assign blanks[0] = 1'b0;
	
endmodule

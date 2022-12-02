module Index_Selector #(parameter width = 26, parameter decimals = 16, parameter LUT_Size = 8)
									(input  logic  [width-1:0]                    input_index,
									 output logic  [LUT_Size-1:0]                   output_index_low,
									 output logic  [LUT_Size-1:0]                   output_index_high,
									 output logic  [decimals - 1:0]               output_index_decimals,
									 output logic      					             direction_low,
									 output logic     					             sign_low,
									 output logic      					             direction_high,
									 output logic     					             sign_high,
									 output logic  [LUT_Size + 1:0]					 index_low,
									 output logic  [LUT_Size + 1:0] 				    index_high,
									 output logic  [LUT_Size - 1:0]               index_high_trunc,
									 output logic  [LUT_Size - 1:0]               index_low_trunc
									 );
			
	//logic [LUT_Size - 1:0] index_high_trunc;
	//logic [LUT_Size - 1:0] index_low_trunc;
			
	assign index_low             = input_index[width-1:decimals];
	assign index_high            = input_index[width-1:decimals] + 1;
	assign direction_low 		  = index_low[LUT_Size];
	assign sign_low     		     = index_low[LUT_Size+1];
	assign direction_high 		  = index_high[LUT_Size];
	assign sign_high     		  = index_high[LUT_Size+1];
	assign index_low_trunc       = index_low[LUT_Size-1:0];
	assign index_high_trunc      = index_high[LUT_Size-1:0];
	assign output_index_decimals = input_index[decimals-1:0];
	always_comb begin
		if (direction_low == 0)
			output_index_low = index_low_trunc;
		else 
			output_index_low = 8'b1111_1111 - index_low_trunc;
	
		
		if (direction_high == 0) 
			output_index_high = index_high_trunc;
		else 
			output_index_high = 8'b1111_1111 - index_high_trunc;
	
	end
	
	/*always_comb
		case(quadrent_low)
			00: output_index_low = index_low_trunc;
			01: output_index_low = 8'b1111_1111 - index_low_trunc;
			10: output_index_low = index_low_trunc;
			11: output_index_low = 8'b1111_1111 - index_low_trunc;
			default: output_index_low = 0;
		endcase
		
	always_comb
		case(quadrent_high)
			00: output_index_high = index_high_trunc;
			01: output_index_high = 8'b1111_1111 - index_high_trunc;//2**LUT_Size-index_high_trunc;
			10: output_index_high = index_high_trunc;
			11: output_index_high = 8'b1111_1111 - index_high_trunc;
			default: output_index_high = 0;
		endcase*/
	
endmodule
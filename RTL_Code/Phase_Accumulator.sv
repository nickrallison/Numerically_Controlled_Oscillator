module Phase_Accumulator #(parameter width = 26, parameter decimals = 16)
								  (input  logic 					 	 clk,
																			 reset_n,
									input  logic  [width-1:0]    increment,
									output logic  [width-1:0] index,
									output logic [width-1:0] next_index);
									
	//logic [LUT_Size + decimals + 1:0] next_index;
	
	always_ff @(posedge clk) begin
		if (!reset_n)
			index <= 0;
		else
			index <= next_index;
	end
	
	always_comb
		if (index > 2 ** (width) - 1)
			next_index = index - (2 ** (width) - 1); // might not mathematically need the minus 1, but it protects from weird overflow
		else
			next_index = increment + index;
	
	
endmodule
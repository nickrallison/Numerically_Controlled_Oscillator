module MovingAvg #(parameter len=9, width=12) //length of 2^len numbers to be averaged
(
  input  logic   				clk,reset_n,
  input  logic [width-1:0] d,
  output logic [width-1:0] result  
);
	// Creating the memory array
	logic [width-1:0] register_pipeline [2**len-1:0];
	logic [width+2**len-2:0] accumulator_result;
	logic [width-1:0] q;
	
	// Assigning the last value to q
	assign q = register_pipeline[2**len-1];
	assign result = accumulator_result >> len;

	// Filling the memory shift register
	always_ff@(posedge clk) begin
		if (reset_n != 1'b1) begin 
			for (int i = 0; i < 2**len; i++)		
				register_pipeline[i] <= 0;
		end
	   else begin 
			for (int i = 1; i < 2**len; i++)
				register_pipeline[i] <= register_pipeline[i-1];
			register_pipeline[0] <= d;
		end
	end
	
	// Module instatiation
	Accumulator #(.len(len), .width(width)) Accumulator_ins(.clk(clk), .reset_n(reset_n), .first(d), .last(q), .out(accumulator_result));
	

endmodule
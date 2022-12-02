
module averager256
#(parameter int  N    = 8,
					  bits = 11)
 (input  logic           clk,
                         EN,      // takes a new sample when high for each clock cycle
                         reset_n,
   input  logic [bits:0] Din,     // input sample for moving average calculation
   output logic [bits:0] Q); 
  
  logic [bits:0] REG_ARRAY [2**N:1];
  logic [N+bits:0] sum;
  logic safe_EN, temp_EN;
  
  
	always_ff @(posedge clk) begin // shift_reg
	
		if(!reset_n) begin
			for(int i = 1; i < 2**N+1; i++) // LoopA1
				REG_ARRAY[i] <= 0;
			Q <= 0;
			sum <= 0;
  
		end
		
		else if(safe_EN) begin
			REG_ARRAY[1] <= Din;
			for(int j = 1; j < 2**N; j++) // LoopA2
				REG_ARRAY[j+1] <= REG_ARRAY[j];
			sum <= sum + Din - REG_ARRAY[256];
			Q <= sum >> N;
		end
	end
  

		
	always_ff @(posedge clk)
		temp_EN <= EN;
		
	assign safe_EN = (!temp_EN)&EN;
		
	
endmodule                                                                     
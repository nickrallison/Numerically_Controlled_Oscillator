module Accumulator #(parameter len=8, width=16)
(
  input  logic   				clk,reset_n,
  input  logic [width-1:0] first, last,
  output logic [width+2**len-2:0] out  
);

	logic [width+2**len-2:0] intermediate;

	always_ff@(posedge clk) begin
		if (reset_n != 1'b1) begin 
			intermediate <= 0;	
			out <= 0;			
		end
	   else begin 
			intermediate <= out + first;
			out <= intermediate - last;
		end
	end

endmodule
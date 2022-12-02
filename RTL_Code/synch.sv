module synch
(
  input  logic clk,reset_n,
  input  logic [9:0] in, 
  output logic [9:0] out 
);
  logic [9:0] intermed;

	always_ff@(posedge clk) begin
		if (reset_n != 0) begin
			intermed <= in;         
			out <= intermed;    
		end
		else begin
			intermed <= 10'b0;         
			out <= 10'b0;
		end
		
	end

endmodule
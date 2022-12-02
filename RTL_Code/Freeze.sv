module Freeze #(parameter width=12)
(
  input  logic clk,reset_n,s,
  input  logic [width-1:0] in, 
  output logic [width-1:0] out,
  output logic [width-1:0] inter
);

	//logic [width-1:0] inter;

	always_ff@(posedge clk) begin
		if (reset_n == 0) begin       
			out <= 'b0;
			inter <= 'b0;
		end
		else if (s == 1) begin
			inter <= in;
			out <= inter;
		end
		else out <= inter;

	end

endmodule
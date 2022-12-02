module Prescaler #(parameter width=12)
( //input  logic       clk,
  //input  logic [1:0] KEY,
  input  logic [width-1:0] in,
  output logic [width:0] result  
);

	logic [width+13:0] intermediate; // width + (clog2(5000) + 1) - 1
	
	assign intermediate = in * 5000;
	assign result = intermediate >> (width - 1);

endmodule
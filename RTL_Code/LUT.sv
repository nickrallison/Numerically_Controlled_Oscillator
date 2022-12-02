module LUT #(parameter width = 32, parameter decimals = 16, parameter LUT_Size = 8, parameter Output_Resolution = 16)
				(input  logic									    clk, 
				 input  logic  [LUT_Size - 1:0] index_low,
				 input  logic  [LUT_Size - 1:0] index_high,
				 input  logic  sign_low,
				 input  logic  sign_high,
				 output logic  [Output_Resolution:0]   output_value_low,
				 output logic  [Output_Resolution:0]   output_value_high);
									
	logic [Output_Resolution-1:0] my_rom[2**LUT_Size-1:0];

	
	initial begin
    $readmemh("C:/Users/nickr/OneDrive/Documents/GitHub/ENEL_453_Digital_Systems_And_HDLs/Lab4/RTL_Code/LUT.txt",my_rom);
   end
	
	always @(posedge clk) begin
		if (sign_low == 0) 
			output_value_low  = {1'b0, my_rom[index_low]};
		else
			output_value_low  = -{1'b0, my_rom[index_low]};
		
		if (sign_high == 0) 
			output_value_high  = {1'b0, my_rom[index_high]};
		else 
			output_value_high  = -{1'b0, my_rom[index_high]};
	end
  
endmodule
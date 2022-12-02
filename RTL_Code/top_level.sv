// top level module
// Watch out for case sensitivity when translating from VHDL.
// Also note that the .QSF is case sensitive.

// Todo: 

parameter width = 32; // Need to choose and have a reason
parameter decimals = 16; // Need to choose and have a reason
  
parameter LUT_Size = 8;
parameter Output_Resolution = 16;

parameter DEFAULT_DIST = 12'h73A;
  

module top_level 
 (input  logic        clk,
  input  logic [1:0]  KEY,
  input  logic [9:0]  SW,
  output logic [9:0]  LEDR,
  output logic [7:0]  HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,
  output logic [15:0] ARDUINO_IO
  
  //output logic [21:0] distance,
  //output logic        direction_low,
  //output logic        sign_low,
  //output logic        direction_high,
  //output logic        sign_high
  
  //output logic  [Output_Resolution:0]   output_value_low,
  //output logic  [Output_Resolution:0]   output_value_high,
  //output logic  [Output_Resolution:0]   out_unscaled,
  //output logic  [Output_Resolution-1:0] out
  );
  
  parameter max_freq = 310_000;
  parameter min_freq = 290_000;
  
  parameter clk_freq = 50_000_000;
  
  logic reset_n;
  logic direction_low;
  logic sign_low;
  logic direction_high;
  logic sign_high;
  logic [2+LUT_Size + decimals - 1:0] increment; 
  logic [LUT_Size-1:0] output_index_low;
  logic [LUT_Size-1:0] output_index_high;
  logic [LUT_Size - 1:0] index_high_trunc;
  logic [LUT_Size - 1:0] index_low_trunc;
  logic [LUT_Size + 1:0] index_low;
  logic [LUT_Size + 1:0] index_high;
  logic [LUT_Size + decimals + 1:0] raw_index;
  logic [decimals - 1:0] index_decimals;
  logic [Output_Resolution:0] output_value_low; // add signed
  logic [Output_Resolution:0] output_value_high; // add signed
  logic [Output_Resolution:0] out_unscaled; // add signed
  logic [Output_Resolution-1:0] out;
  logic [Output_Resolution-1:0] final_out;
  logic [Output_Resolution-1:0] AM_out;
  logic [12:0] jump_dist;
  logic [15:0] distance_bcd;
  logic [5:0]  DP_in;
  logic [5:0]  blanks;
  
  logic [11:0] adc_raw;
  logic [11:0] adc_avg;
  logic [12:0] voltage_avg;
  logic [12:0] dist_avg;
  
  logic [3:0]  Num_Hex0, Num_Hex1, Num_Hex2, Num_Hex3, Num_Hex4, Num_Hex5;
  
  
  // #### Testing #### 
  assign reset_n = KEY[0];
  assign LEDR[9:0] = SW[9:0];
  
  assign DP_in = 6'b000100;
  
  assign Num_Hex0 = distance_bcd[3:0]; 
  assign Num_Hex1 = distance_bcd[7:4];
  assign Num_Hex2 = distance_bcd[11:8];
  assign Num_Hex3 = distance_bcd[15:12];
  assign Num_Hex4 = 4'b0000;
  assign Num_Hex5 = 4'b0000;
  
  
   ADC_Data ADC_Data_ins(.clk(clk), 
								.reset_n(reset_n),
								.voltage(voltage_avg),
								.distance(dist_avg),
								.ADC_raw(adc_raw),
								.ADC_out(adc_avg));
								
	SevenSegment SevenSeg_ins(.Num_Hex0(Num_Hex0),
                            .Num_Hex1(Num_Hex1),
                            .Num_Hex2(Num_Hex2),
                            .Num_Hex3(Num_Hex3),
                            .Num_Hex4(Num_Hex4),
                            .Num_Hex5(Num_Hex5),
                            .Hex0(HEX0),
                            .Hex1(HEX1),
                            .Hex2(HEX2),
                            .Hex3(HEX3),
                            .Hex4(HEX4),
                            .Hex5(HEX5),
                            .DP_in(DP_in),
									 .Blank(blanks));
									 
	blanker blanker_ins(.input_signal({Num_Hex5, Num_Hex4, Num_Hex3, Num_Hex2, Num_Hex1, Num_Hex0}),
							 .DP_in(DP_in),
							 .blanks(blanks));
									 
	binary_bcd binary_bcd_distance(.clk(clk),                          
										   .reset_n(reset_n),                                 
                                 .binary(dist_avg),    
                                 .bcd(distance_bcd));
								
  //MovingAvg          MovingAvg_ins(.clk(clk), .reset_n(reset_n), .d(adc_raw), .result(adc_avg));
  //Prescaler          Prescaler_ins(.in(adc_avg), .result(voltage_avg));
  //Linearizer         Linearizer_ins(.in(voltage_avg), .result(dist_avg));

  MUX2TO1 #(13) FM_MUX(.in1({1'b0, DEFAULT_DIST}),
							  .in2(dist_avg),
							  .s(SW[8]),
							  .mux_out(jump_dist));

  // #### Dist -> Freq #### (4, 30) --> (5.9392, 6.3488) // in is sized to 6 + decimals, out is sized to 2+LUT_Size+decimals
  DIST2JUMP #(13,2+LUT_Size+decimals,decimals) DIST2JUMP_ins(.in(jump_dist), .out(increment)); 
  // in: distance (32, 16) fixed point, out: jump (32, 16) fixed point
  
  // #### Counter LUT Indexing ####
  
  Phase_Accumulator #(2+LUT_Size+decimals,decimals) Phase_Accumulator_ins(.clk(clk), .reset_n(reset_n), .increment(increment), .index(raw_index));
  // raw index: xx_yyyyyyyy_zzz..., x is quadrant, y interger part, z is decimal part  (26, 16) fixed point
  
  Index_Selector #(2+LUT_Size+decimals, decimals, LUT_Size) Index_Selector_ins(.input_index(raw_index),  
                                                 .output_index_low(output_index_low), 
										                   .output_index_high(output_index_high), 
																 .index_low(index_low),
																 .index_high(index_high),
									                      .output_index_decimals(index_decimals),
									                      .direction_low(direction_low),
									                      .sign_low(sign_low),
																 .direction_high(direction_high),
									                      .sign_high(sign_high),
																 .index_low_trunc(index_low_trunc),
																 .index_high_trunc(index_high_trunc));
  // Index is normalized sin table index (fixed point, 8 integer bits from table len, 16 from decimal
  
  LUT #(width, decimals, LUT_Size, Output_Resolution) 			LUT_ins(	.clk(clk), 
													.index_low(output_index_low), 
													.index_high(output_index_high), 
													.output_value_low(output_value_low), 
													.output_value_high(output_value_high),
													.sign_high(sign_high),
													.sign_low(sign_low));
													
  Lerp #(Output_Resolution+1, decimals) Lerp_ins(.first(output_value_low), .second(output_value_high), .frac(index_decimals), .out(out_unscaled));
  
  // #### Normalization ####
  assign out = (out_unscaled + 16'hffff) >> 1;
  
  //Amplitude_Modulator 
  DIST2AMP #(16,16,20) DIST2AMP_ins(.wave(out), .distance(dist_avg), .out(AM_out)); 

  MUX2TO1 #(Output_Resolution) AM_MUX(.in1(out),
																  .in2(AM_out),
																  .s(SW[9]),
																  .mux_out(final_out));
  
  assign ARDUINO_IO[5:0] = final_out >> 10;
  
  // #### Output ####
  //PWM_DAC #(4) PWM_DAC_ins (.clk(clk), .duty_cycle(out >> 12), .count_value(4'hf), .pwm_out(ARDUINO_IO[0]));
  
  // #### Debouncing and Synching ####
  
  //synch 							synch_ins(.clk(clk), .reset_n(reset_n), .in(SW), .out(synched_sw));
  //assign synched_sw = SW;
  //debounce #(1_000_000,30) debounce_ins(.clk(clk),     // 30us bounce time at 1MHz               
  //												    .reset_n(reset_n), 
  //												    .button(KEY[0]),  
  //												    .result(freeze));
													 
  		 
  endmodule

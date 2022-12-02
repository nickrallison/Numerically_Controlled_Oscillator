module PWM_DAC
 #(int                        width = 16)
  (input  logic               clk,
   input  logic [width-1:0]   duty_cycle, count_value,
   output logic               pwm_out);

  int counter;//,duty_cycle_int,count_value_int;

  always_ff @(posedge clk) begin
      if (counter < count_value)
        counter++;
      else
        counter <= 0;
  end

  always_comb begin
    if (counter < duty_cycle)
      pwm_out = 1;
    else 
      pwm_out = 0;
  end

endmodule
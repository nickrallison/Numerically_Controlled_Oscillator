module Linearizer #(parameter width=13, precision=8) // precision is how many mv are per reading
(
	input  logic   	  mode_close,
	input  logic [12:0] in,
	output logic [12:0] result,
	output logic [12:0] cmF,
	output logic [12:0] cmS,
	output logic [4:0]  trunc,
	output logic [25:0] mult, sub, shift
);

	//parameter storedlen = (5000 + 2 ** precision + 1) / (2 ** precision);

	logic [4:0] selector;
	logic [12:0] distStoredClose [14];
	logic [12:0] distStoredFar [14];
	
	assign selector = in >> 8; // Which Registers are accessed
	assign trunc = in[7:0];  // Truncated Reading for Lerp
	
	// #### Distance Measurement Hard Coded - Precision must set to 8 ####
	assign distStoredClose[0] = 0;      // 0mV    
	assign distStoredClose[1] = 0;      // 256mV  
	assign distStoredClose[2] = 0;      // 512mV  
	assign distStoredClose[3] = 0;      // 768mV  
	assign distStoredClose[4] = 0;      // 1024mV 
	assign distStoredClose[5] = 0;      // 1280mV 
	assign distStoredClose[6] = 0;      // 1536mV
	assign distStoredClose[7] = 0;      // 1792mV 
	assign distStoredClose[8] = 79;     // 2048mV 
	assign distStoredClose[9] = 95;     // 2304mV 
	assign distStoredClose[10] = 111;   // 2560mV 
	assign distStoredClose[11] = 143;   // 2816mV 
	assign distStoredClose[12] = 190;   // 3072mV
   assign distStoredClose[13] = 190;   // 33xxmV	
	
	// #### Far Distances ####
	assign distStoredFar[0] = 8190;      // 0mV   
	assign distStoredFar[1] = 4826;       // 256mV  
	assign distStoredFar[2] = 2223;       // 512mV  
	assign distStoredFar[3] = 1492;       // 768mV  
	assign distStoredFar[4] = 1099;       // 1024mV 
	assign distStoredFar[5] = 794;        // 1280mV 
	assign distStoredFar[6] = 635;        // 1536mV 
	assign distStoredFar[7] = 524;        // 1792mV 
	assign distStoredFar[8] = 381;        // 2048mV 
	assign distStoredFar[9] = 318;        // 2304mV 
	assign distStoredFar[10] = 286;       // 2560mV 
	assign distStoredFar[11] = 254;       // 2816mV 
 	assign distStoredFar[12] = 190;       // 3072mV 
 	assign distStoredFar[13] = 190;       // 33xxmV
	
	always_comb begin
		if (mode_close == 0) begin
			cmS = distStoredClose[selector];	    // Low Bound for Lerp
			cmF = distStoredClose[selector + 1]; // High Bound for Lerp
		end
		else begin
			cmS = distStoredFar[selector];	    // Low Bound for Lerp
			cmF = distStoredFar[selector + 1];   // High Bound for Lerp
		end
	end
	
	Lerp #(13, 8) Lerp_ins(.first(cmS), .second(cmF), .frac(trunc), .out(result));
	
endmodule
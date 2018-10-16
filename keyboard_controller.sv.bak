module keyboard_controller(input logic clk,
									input logic PS2_clk,
									input logic PS2_DATA,
									output logic [7:0] pressedKey);
					//Codigos ps/2
					localparam  [7:0] ARROW_UP 		= 8'h75;	
					localparam  [7:0] ARROW_DOWN 		= 8'h72;
					localparam  [7:0] ARROW_LEFT 		= 8'h6B;
					localparam  [7:0] ARROW_RIGHT 	= 8'h74;	
					localparam  [7:0] SPACE 			= 8'h29;	
									
					
					logic read;				
					logic [11:0] count_reading;		
					logic PREVIOUS_STATE;			
					logic scan_err;				
					logic [10:0] scan_code;			
					logic [7:0] CODEWORD;			
					logic TRIG_ARR;				
					logic [3:0]COUNT;				
					logic TRIGGER = 0;			
					logic [7:0]DOWNCOUNTER = 0;		
									
									
					initial begin
						PREVIOUS_STATE = 1;		
						scan_err = 0;		
						scan_code = 0;
						COUNT = 0;			
						CODEWORD = 0;
						pressedKey = 0;
						read = 0;
						count_reading = 0;
					end

					always_ff @(posedge clk) begin				
						if (DOWNCOUNTER < 249) begin			
							DOWNCOUNTER <= DOWNCOUNTER + 1;
							TRIGGER <= 0;
						end
						else begin
							DOWNCOUNTER <= 0;
							TRIGGER <= 1;
						end
					end
					
					always_ff @(posedge clk) 
						begin	
							if (TRIGGER) 
								begin
									if (read)				
										count_reading <= count_reading + 1;	
									else 						
										count_reading <= 0;	
								end
						end


					always_ff @(posedge clk) 
						begin		
							if (TRIGGER) 
								begin						
									if (PS2_clk != PREVIOUS_STATE) 
										begin		
											if (!PS2_clk) 
												begin				
													read <= 1;				
													scan_err <= 0;				
													scan_code[10:0] <= {PS2_DATA, scan_code[10:1]};	
													COUNT <= COUNT + 1;			
												end
										end
									else if (COUNT == 11) 
										begin				
											COUNT <= 0;
											read <= 0;					
											TRIG_ARR <= 1;					
											if (!scan_code[10] || scan_code[0] || !(scan_code[1]^scan_code[2]^scan_code[3]^scan_code[4]^scan_code[5]^scan_code[6]^scan_code[7]^scan_code[8]^scan_code[9]))
												scan_err <= 1;
											else 
												scan_err <= 0;
										end	
									else  
										begin						
											TRIG_ARR <= 0;					
											if (COUNT < 11 && count_reading >= 4000) 
												begin	
													COUNT <= 0;				
													read <= 0;				
												end
										end
										PREVIOUS_STATE <= PS2_clk;				
								end
						end


					always @(posedge clk) 
						begin
							if (TRIGGER) 
								begin					
									if (TRIG_ARR)
										begin				
											if (scan_err) 
												begin			
													CODEWORD <= 8'd0;		
												end
											else 
												begin
													CODEWORD <= scan_code[8:1];	
												end				
										end					
									else 
										CODEWORD <= 8'd0;				
								end
							else 
								CODEWORD <= 8'd0;					
						end
					
					always_ff @(posedge clk) 
						begin
							pressedKey<=scan_code[8:1];			
							if (CODEWORD == ARROW_UP)				
								pressedKey <= pressedKey + 1;	
							else if (CODEWORD == ARROW_DOWN)			
								pressedKey <= pressedKey - 1;	
						end

endmodule
			
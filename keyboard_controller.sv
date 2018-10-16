module keyboard_controller(input logic CLK,
									input logic PS2_clk,
									input logic PS2_DATA,
									output logic [7:0] pressedKey);
					//Codigos ps/2
					//https://wiki.osdev.org/PS/2_Keyboard
					localparam  [7:0] ARROW_UP 		= 8'h75;	
					localparam  [7:0] ARROW_DOWN 		= 8'h72;
					localparam  [7:0] ARROW_LEFT 		= 8'h6B;
					localparam  [7:0] ARROW_RIGHT 	= 8'h74;	
					localparam  [7:0] SPACE 			= 8'h29;	
					localparam  [7:0] CLK_DIVISION   = 2500;
					//falta probar estos codigos y lo mejor seria sacar esto del modulo para hacerlo generico
					
					//--------------------------Iniciamos creando variables-----------------------------------------
					logic READ;				
					logic [11:0] READ_COUNT;		
					logic PREVIOUS_STATE;			
					logic scan_err;				
					logic [10:0] scan_code;			
					logic [7:0] CODEWORD;			
					logic TRIG_ARR;				
					logic [3:0]COUNT;				
					logic TEMP_PS2_CLK = 0;			
					logic [7:0]CLK_COUNTER = 0;
			      //----------------------------------------------------------------------------------------------		
									
					//---------------------Le damos valor inicial a las variables-----------------------------------
					initial begin
						PREVIOUS_STATE = 1;		
						scan_err = 0;		
						scan_code = 0;
						COUNT = 0;			
						CODEWORD = 0;
						pressedKey = 0;
						READ = 0;
						READ_COUNT = 0;
					end
					//----------------------------------------------------------------------------------------------
					
					//-----------Aqui escalo la frecuencia del CLK de 50Mhz a la del PS/2---------------------------
					always_ff @(posedge CLK) begin				
						if (CLK_COUNTER < CLK_DIVISION) begin			
							CLK_COUNTER <= CLK_COUNTER + 1;
							TEMP_PS2_CLK <= 0;
						end
						else begin
							CLK_COUNTER <= 0;
							TEMP_PS2_CLK <= 1;
						end
					end
					//----------------------------------------------------------------------------------------------
					
					
					
					//-----------Ahora si ya no queremos leer mas datos del teclado entonces paramos----------------
					always_ff @(posedge CLK) 
						begin	
							if (TEMP_PS2_CLK) 
								begin
									if (READ)				
										READ_COUNT <= READ_COUNT + 1;	
									else 						
										READ_COUNT <= 0;	
								end
						end
					//----------------------------------------------------------------------------------------------	
					

					//-----------Aqui escalo la frecuencia del CLK de 50Mhz a la del PS/2---------------------------
					always_ff @(posedge CLK) 
						begin		
							if (TEMP_PS2_CLK) 
								begin						
									if (PS2_clk != PREVIOUS_STATE) 
										begin		
											if (!PS2_clk) 
												begin				
													READ <= 1;				
													scan_err <= 0;				
													scan_code[10:0] <= {PS2_DATA, scan_code[10:1]};	
													COUNT <= COUNT + 1;			
												end
										end
									else if (COUNT == 11) 
										begin				
											COUNT <= 0;
											READ <= 0;					
											TRIG_ARR <= 1;					
											if (!scan_code[10] || scan_code[0] || !(scan_code[1]^scan_code[2]^scan_code[3]^scan_code[4]^scan_code[5]^scan_code[6]^scan_code[7]^scan_code[8]^scan_code[9]))
												scan_err <= 1;
											else 
												scan_err <= 0;
										end	
									else  
										begin						
											TRIG_ARR <= 0;					
											if (COUNT < 11 && READ_COUNT >= 4000) 
												begin	
													COUNT <= 0;				
													READ <= 0;				
												end
										end
										PREVIOUS_STATE <= PS2_clk;				
								end
						end
					//-----------------------------------------------------------------------------------------------

					//-----------Aqui escalo la frecuencia del CLK de 50Mhz a la del PS/2----------------------------
					always @(posedge CLK) 
						begin
							if (TEMP_PS2_CLK) 
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
					//-----------------------------------------------------------------------------------------------
					//-----------Aqui escalo la frecuencia del CLK de 50Mhz a la del PS/2----------------------------
					always_ff @(posedge CLK) 
						begin
							pressedKey<=scan_code[8:1];			
							if (CODEWORD == ARROW_UP)				
								pressedKey <= pressedKey + 1;	
							else if (CODEWORD == ARROW_DOWN)			
								pressedKey <= pressedKey - 1;	
						end
					//-----------------------------------------------------------------------------------------------

endmodule
			
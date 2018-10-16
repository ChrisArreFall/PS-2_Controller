module keyboard_controller(input logic CLK,
									input logic PS2_CLK,
									input logic PS2_DATA,
									output logic [7:0] pressedKey);
					//Codigos ps/2
					//https://wiki.osdev.org/PS/2_Keyboard
					localparam  [7:0] ARROW_UP 		= 8'h75;	
					localparam  [7:0] ARROW_DOWN 		= 8'h72;
					localparam  [7:0] ARROW_LEFT 		= 8'h6B;
					localparam  [7:0] ARROW_RIGHT 	= 8'h74;	
					localparam  [7:0] SPACE 			= 8'h29;	
					localparam  [7:0] CLK_DIVISION   = 250;
					localparam  [7:0] N_BITS         = 11;
					localparam  [16:0] TIME_LIMIT    = 4000;
					//falta probar estos codigos y lo mejor seria sacar esto del modulo para hacerlo generico
					
					//--------------------------Iniciamos creando variables-----------------------------------------
					logic READ;				
					logic [11:0] READ_COUNT;		
					logic PREVIOUS_STATE;			
					logic ERROR_BIT;				
					logic [10:0] RECIVIED_CODE;			
					logic [7:0] CODEWORD;			
					logic COMPLETED_DATA;				
					logic [3:0]BITS_COUNT;				
					logic TEMP_PS2_CLK = 0;			
					logic [7:0]CLK_COUNTER = 0;
			      //----------------------------------------------------------------------------------------------		
									
					//---------------------Le damos valor inicial a las variables-----------------------------------
					initial begin
						PREVIOUS_STATE = 1;		
						ERROR_BIT = 0;		
						RECIVIED_CODE = 0;
						BITS_COUNT = 0;			
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
					

					//---Aqui reviso si ya nos llego todos los bits del codigo y tambien revisamos si hay errores---
					always_ff @(posedge CLK) 
						begin		
							if (TEMP_PS2_CLK) 
								begin						
									if (PS2_CLK != PREVIOUS_STATE) 
										begin		
											if (!PS2_CLK) 
												begin				
													READ <= 1;				
													ERROR_BIT <= 0;				
													RECIVIED_CODE[N_BITS-1:0] <= {PS2_DATA, RECIVIED_CODE[N_BITS-1:1]};	
													BITS_COUNT <= BITS_COUNT + 1;			
												end
										end
									else if (BITS_COUNT == N_BITS) 
										begin				
											BITS_COUNT <= 0;
											READ <= 0;					
											COMPLETED_DATA <= 1;					
											if (!RECIVIED_CODE[N_BITS-1] || RECIVIED_CODE[0] || !(RECIVIED_CODE[1]^RECIVIED_CODE[2]^RECIVIED_CODE[3]^RECIVIED_CODE[4]^RECIVIED_CODE[5]^RECIVIED_CODE[6]^RECIVIED_CODE[7]^RECIVIED_CODE[8]^RECIVIED_CODE[9]))
												ERROR_BIT <= 1;
											else 
												ERROR_BIT <= 0;
										end	
									else  
										begin						
											COMPLETED_DATA <= 0;					
											if (BITS_COUNT < N_BITS && READ_COUNT >= TIME_LIMIT) 
												begin	
													BITS_COUNT <= 0;				
													READ <= 0;				
												end
										end
										PREVIOUS_STATE <= PS2_CLK;	//esto guarda el estado anterior del clk del ps2			
								end
						end
					//-----------------------------------------------------------------------------------------------

					//-----------Aqui escalo la frecuencia del CLK de 50Mhz a la del PS/2----------------------------
					always @(posedge CLK) 
						begin
							if (TEMP_PS2_CLK) 
								begin					
									if (COMPLETED_DATA)
										begin				
											if (ERROR_BIT) 
												begin			
													CODEWORD <= 8'd0;		
												end
											else 
												begin
													CODEWORD <= RECIVIED_CODE[8:1];	
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
							pressedKey<=RECIVIED_CODE[8:1];			
							if (CODEWORD == ARROW_UP)				
								pressedKey <= pressedKey + 1;	
							else if (CODEWORD == ARROW_DOWN)			
								pressedKey <= pressedKey - 1;	
						end
					//-----------------------------------------------------------------------------------------------

endmodule
			
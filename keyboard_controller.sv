module keyboard_controller(input logic PS2_CLK,
									input logic PS2_DATA,
									output logic [7:0] KB_CODE);
					logic [7:0] CURRENT_DATA;
					logic [7:0] PREVIOUS_DATA;
					logic [3:0] BIT_COUNTER;
					logic FLAG;
					//--------------------------------Variables iniciales--------------------------------
					initial
						begin
							BIT_COUNTER<=4'h1;  						//Estos bits son el contador de los datos ingresador del keyboard
							FLAG<=1'b0;									//Este bit nos dice si ya nos llego todos los datos
							CURRENT_DATA<=8'hf0;						//Estos bits son los datos actuales
							PREVIOUS_DATA<=8'hf0;					//Estos bits son los nuevos datos
							KB_CODE<=8'hf0;							//bits para almacenar el codigo completo
						end
					//------------Activamos en negativo el clk del keyboard y leemos los datos------------
					//Los datos se envían en paquetes de 11 bits. 
					//Primer bit de inicio “0”,
					//despues los datos importantes en los 8 bits siguientes,
					//posteriormente el penultimo bit es de paridad.
					//finalmente terminamos reseteando el bit del flag en 0
					always @(negedge PS2_CLK)
						begin
							case(BIT_COUNTER)
								1:; 										//primer bit
								2:CURRENT_DATA[0]<=PS2_DATA;		//segundo bit
								3:CURRENT_DATA[1]<=PS2_DATA;		//tercero bit
								4:CURRENT_DATA[2]<=PS2_DATA;		//cuarto bit
								5:CURRENT_DATA[3]<=PS2_DATA;		//quinto bit
								6:CURRENT_DATA[4]<=PS2_DATA;		//sexto bit
								7:CURRENT_DATA[5]<=PS2_DATA;		//setimo bit
								8:CURRENT_DATA[6]<=PS2_DATA;		//octavo bit
								9:CURRENT_DATA[7]<=PS2_DATA;		//noveno bit
								10:FLAG<=1'b1; 						//paridad bit
								11:FLAG<=1'b0; 						//ultimo bit
							endcase
						if(BIT_COUNTER<=10)
							BIT_COUNTER<=BIT_COUNTER+1;
						else if(BIT_COUNTER==11)
							BIT_COUNTER<=1;
						end
					//------------Finalmente guardamos el codigo obtenido en la salida del modulo----------
					always@(posedge FLAG) 
						begin
							if(CURRENT_DATA==8'hf0)
								KB_CODE<=PREVIOUS_DATA;
							else
								PREVIOUS_DATA<=CURRENT_DATA;
						end
endmodule
			
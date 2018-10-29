module testKeyboard(input logic CLK,		
						  input logic PS2_CLK,		
						  input logic PS2_DATA,		
						  //output logic [7:0] pressedKey,
						  output logic [6:0] hex1,hex0);
		//Codigos ps/2
		//https://wiki.osdev.org/PS/2_Keyboard
		localparam  [7:0] ARROW_UP 		= 8'h75;	
		localparam  [7:0] ARROW_DOWN 		= 8'h72;
		localparam  [7:0] ARROW_LEFT 		= 8'h6B;
		localparam  [7:0] ARROW_RIGHT 	= 8'h74;	
		localparam  [7:0] SPACE 			= 8'h29;	
		logic [7:0] pressedKey = 0;
		
		//mejor se saco estos codigos del modulo para asi tener uno generico para futuros proyectos
		keyboard_controller keyboard_controller_F (.PS2_CLK(PS2_CLK),.PS2_DATA(PS2_DATA),.CODE(pressedKey));
		sevenSegmentDisplay sevenSegmentDisplay_F_1 (pressedKey[3:0],hex0);
		sevenSegmentDisplay sevenSegmentDisplay_F_2 (pressedKey[7:4],hex1);
		
endmodule

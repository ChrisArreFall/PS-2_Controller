module testKeyboard(input logic CLK,		
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
		//mejor se saco estos codigos del modulo para asi tener uno generico para futuros proyectos
		keyboard_controller keyboard_controller_F (.CLK(CLK),.PS2_CLK(PS2_CLK),.PS2_DATA(PS2_DATA),.pressedKey(pressedKey));
endmodule

module kb_controller_tb();

	// Inputs
	logic CLK;
	logic PS2_CLK;
	logic PS2_DATA;

	// Outputs
	logic [7:0]CODEWORD;

	// Instantiate the Unit Under Test (UUT)
	keyboard_controller uut (
		.CLK(CLK), 
		.PS2_CLK(PS2_CLK), 
		.PS2_DATA(PS2_DATA),
		.pressedKey(CODEWORD)
	);

	initial begin
		CLK = 1;
		for(int i = 0; i < 2000; i++) begin
		#1 CLK = ~CLK;
		end
	end
	
	initial begin
		// Initialize Inputs
		PS2_CLK = 1;
		PS2_DATA = 1;

		// Wait 100 ns for global reset to finish
		#100;
		
      #45 PS2_DATA = 0; //START 0
		#5 PS2_CLK = 0;
		#50 PS2_CLK = 1;
		
		#45 PS2_DATA = 1; //1
		#5 PS2_CLK = 0;
		#50 PS2_CLK = 1;
		
		#45 PS2_DATA = 0; //2
		#5 PS2_CLK = 0;
		#50 PS2_CLK = 1;

		#45 PS2_DATA = 1; //3
		#5 PS2_CLK = 0;
		#50 PS2_CLK = 1;
		
		#45 PS2_DATA = 0; //4
		#5 PS2_CLK = 0;
		#50 PS2_CLK = 1;
		
		#45 PS2_DATA = 1; //5
		#5 PS2_CLK = 0;
		#50 PS2_CLK = 1;

		#45 PS2_DATA = 1; //6
		#5 PS2_CLK = 0;
		#50 PS2_CLK = 1;
		
		#45 PS2_DATA = 1; //7
		#5 PS2_CLK = 0;
		#50 PS2_CLK = 1;
		
		#45 PS2_DATA = 0; //8
		#5 PS2_CLK = 0;
		#50 PS2_CLK = 1;
		
		#45 PS2_DATA = 0; //PARITY 9
		#5 PS2_CLK = 0;
		#50 PS2_CLK = 1;
		
		#45 PS2_DATA = 1;// STOP 10
		#5 PS2_CLK = 0;
		#50 PS2_CLK = 1;
		// Add stimulus here
		
		#45 PS2_DATA = 0; //START 0
		#5 PS2_CLK = 0;
		#50 PS2_CLK = 1;
		
		#45 PS2_DATA = 0; //1
		#5 PS2_CLK = 0;
		#50 PS2_CLK = 1;
		
		#45 PS2_DATA = 0; //2
		#5 PS2_CLK = 0;
		#50 PS2_CLK = 1;

		#45 PS2_DATA = 0; //3
		#5 PS2_CLK = 0;
		#50 PS2_CLK = 1;
		
		#45 PS2_DATA = 0; //4
		#5 PS2_CLK = 0;
		#50 PS2_CLK = 1;
		
		#45 PS2_DATA = 1; //5
		#5 PS2_CLK = 0;
		#50 PS2_CLK = 1;

		#45 PS2_DATA = 1; //6
		#5 PS2_CLK = 0;
		#50 PS2_CLK = 1;
		
		#45 PS2_DATA = 1; //7
		#5 PS2_CLK = 0;
		#50 PS2_CLK = 1;
		
		#45 PS2_DATA = 1; //8
		#5 PS2_CLK = 0;
		#50 PS2_CLK = 1;
		
		#45 PS2_DATA = 1; //PARITY 9
		#5 PS2_CLK = 0;
		#50 PS2_CLK = 1;
		
		#45 PS2_DATA = 1;// STOP 10
		#5 PS2_CLK = 0;
		#50 PS2_CLK = 1;
	//BRAKE CODE
		#45 PS2_DATA = 0; //START 0
		#5 PS2_CLK = 0;
		#50 PS2_CLK = 1;
		
		#45 PS2_DATA = 1; //1
		#5 PS2_CLK = 0;
		#50 PS2_CLK = 1;
		
		#45 PS2_DATA = 0; //2
		#5 PS2_CLK = 0;
		#50 PS2_CLK = 1;

		#45 PS2_DATA = 1; //3
		#5 PS2_CLK = 0;
		#50 PS2_CLK = 1;
		
		#45 PS2_DATA = 0; //4
		#5 PS2_CLK = 0;
		#50 PS2_CLK = 1;
		
		#45 PS2_DATA = 1; //5
		#5 PS2_CLK = 0;
		#50 PS2_CLK = 1;

		#45 PS2_DATA = 1; //6
		#5 PS2_CLK = 0;
		#50 PS2_CLK = 1;
		
		#45 PS2_DATA = 1; //7
		#5 PS2_CLK = 0;
		#50 PS2_CLK = 1;
		
		#45 PS2_DATA = 0; //8
		#5 PS2_CLK = 0;
		#50 PS2_CLK = 1;
		
		#45 PS2_DATA = 0; //PARITY 9
		#5 PS2_CLK = 0;
		#50 PS2_CLK = 1;
		
		#45 PS2_DATA = 1;// STOP 10
		#5 PS2_CLK = 0;
		#50 PS2_CLK = 1;
	end
      

endmodule

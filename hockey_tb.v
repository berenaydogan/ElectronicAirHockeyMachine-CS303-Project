module hockey_tb();


parameter HP = 5;       // Half period of our clock signal
parameter FP = (2*HP);  // Full period of our clock signal

reg clk, rst, BTN_A, BTN_B;
reg [1:0] DIR_A;
reg [1:0] DIR_B;
reg [2:0] Y_in_A;
reg [2:0] Y_in_B;

wire [2:0] X_COORD, Y_COORD;

// Our design-under-test is the DigiHockey module
hockey dut(clk, rst, BTN_A, BTN_B, DIR_A, DIR_B, Y_in_A, Y_in_B, X_COORD,Y_COORD);

// This always statement automatically cycles between clock high and clock low in HP (Half Period) time. Makes writing test-benches easier.
always #HP clk = ~clk;

initial begin
    $dumpfile("hockey.vcd"); //  * Our waveform is saved under this file.
    $dumpvars(0,hockey_tb); // * Get the variables from the module.
    $display("Simulation started.");

	// Initialize variables
	clk = 0; 
    rst = 0;
    BTN_A = 0;
	BTN_B = 0;
	DIR_A = 0;
	DIR_B = 0;
    Y_in_A = 0;
    Y_in_B = 0;
    

	// Test 1
	// Reset 
	rst = 1;
	#FP;
	rst = 0;
	#FP;

	// Player A starts the game
	BTN_A = 1; 
	#FP;
	BTN_A = 0;
	#(4*FP);

	// HIT_A state, take inputs Y_IN_A and DIR_A
	Y_in_A = 2;
	DIR_A = 0;
	#FP;

	// Pressing BTN_A go to SEND_B state
	BTN_A = 1; 
	#FP;
	BTN_A = 0;

	// Take inputs Y_IN_B and BTN_B, Y_IN_B not equal to Puck's current Y position, go to GOAL_A state
	#(20*FP);
	Y_in_B = 3; 
	#FP;
	BTN_B = 1;
    #(2*FP); 
	BTN_B = 0;
	#(2*FP);

	// GOAL_A state, score (1-0)
	#(5*FP);
	
	// HIT_B state, Take inputs Y_IN_B and BTN_B 
	Y_in_B = 1;
	DIR_B = 1;
	#FP;

	// Pressing BTN_B go to SEND_A state
	BTN_B = 1; 
	#FP;
	BTN_B = 0;

	// Take inputs Y_IN_A and BTN_A, Y_IN_A equal to Puck's Y position, go to SEND_B state
	#(20*FP);
	Y_in_A = 3; 
	#FP;
	BTN_A = 1;
	#FP; 
	BTN_A = 0;
	
	// Take inputs Y_IN_B and BTN_B, Y_IN_B equal to Puck's Y position, go to SEND_A state
	#(15*FP);
	Y_in_B = 3;
	#FP; 
	BTN_B = 1;
	#FP; 
	BTN_B = 0;

	// Take inputs Y_IN_A and BTN_A, Y_IN_A not equal to Puck's Y position, go to GOAL_B state
	#(15*FP);
	Y_in_A = 2;
	#FP;
	BTN_A = 1;
	#(2*FP); 
	BTN_A = 0;
	#(2*FP); 
	
	// GOAL_B state, score (1-1)
	#(5*FP); 

	// HIT_A state, take inputs Y_IN_A and DIR_A
	Y_in_A = 2;
	DIR_A = 2;
	#FP;

	// Pressing BTN_A go to SEND_B state
	BTN_A = 1; 
	#FP;
	BTN_A = 0;

	// Take inputs Y_IN_B and BTN_B, Y_IN_B not equal to Puck's current Y position
	#(20*FP);
	Y_in_B = 3; 
	#FP;
	BTN_B = 1;
    #(2*FP); 
	BTN_B = 0;
	#(2*FP);

	// GOAL_A state, score (2-1)
	#(5*FP); 

	// HIT_B state, Take inputs Y_IN_B and BTN_B 
	Y_in_B = 3;
	DIR_B = 0;
	#FP;

	// Pressing BTN_B go to SEND_A state
	BTN_B = 1; 
	#FP;
	BTN_B = 0;

	// Take inputs Y_IN_A and BTN_A, Y_IN_A equal to Puck's Y position, go to SEND_B state
	#(20*FP);
	Y_in_A = 3; 
	#FP;
	BTN_A = 1;
	#FP; 
	BTN_A = 0;

	// Take inputs Y_IN_B and BTN_B, Y_IN_B equal to Puck's Y position, go to SEND_A state
	#(15*FP);
	Y_in_B = 1;
	#FP;
	BTN_B = 1;
	#FP; 
	BTN_B = 0;

	// Take inputs Y_IN_A and BTN_A, Y_IN_A equal to Puck's Y position, go to SEND_B state
	#(15*FP);
	Y_in_A = 1; 
	#FP;
	BTN_A = 1;
	#FP; 
	BTN_A = 0;

	// Take inputs Y_IN_B and BTN_B, Y_IN_B not equal to Puck's Y position, go to GOAL_A state
	#(15*FP);
	Y_in_B = 0;
	#FP;
	BTN_B = 1;
	#(2*FP); 
	BTN_B = 0;
	#(2*FP); 

	// GOAL_A state, score (3-1), game over
	#(5*FP);
	
	// Test 2
	BTN_A = 0;
	BTN_B = 0;
	DIR_A = 0;
	DIR_B = 0;
    Y_in_A = 0;
    Y_in_B = 0;
	// Reset 
	rst = 1;
	#FP;
	rst = 0;
	#FP;

	// Player B starts the game
	BTN_B = 1; 
	#FP;
	BTN_B = 0;
	#(4*FP);

	// HIT_B state, Take inputs Y_IN_B and BTN_B
	Y_in_B = 4;
	DIR_B = 2;
	#FP;

	// Pressing BTN_B go to SEND_A state
	BTN_B = 1; 
	#FP
	BTN_B = 0;

	// Take inputs Y_IN_A and BTN_A, Y_IN_A equal to Puck's current Y position, go to SEND_B state
	#(20*FP);
	Y_in_A = 0; 
	#FP;
	BTN_A = 1;
    #FP; 
	BTN_A = 0;

	// Take inputs Y_IN_B and BTN_B, Y_IN_B not equal to Puck's Y position, go to GOAL_A state
	#(15*FP);
	Y_in_B = 4;
	#FP;
	BTN_B = 1;
	#(2*FP); 
	BTN_B = 0;
	#(2*FP); 

	// GOAL_A state, score (1-0)
	#(5*FP);
	
	// HIT_B state, Take inputs Y_IN_B and BTN_B 
	Y_in_B = 1;
	DIR_B = 0;
	#FP;

	// Pressing BTN_B go to SEND_A state
	BTN_B = 1; 
	#FP;
	BTN_B = 0;

	// Take inputs Y_IN_A and BTN_A, Y_IN_A not equal to Puck's Y position, go to GOAL_B state
	#(20*FP);
	Y_in_A = 4; 
	#FP;
	BTN_A = 1;
	#(2*FP); 
	BTN_A = 0;
	#(2*FP); 
	
	// GOAL_B state, score (1-1)
	#(5*FP); 

	// HIT_A state, take inputs Y_IN_A and DIR_A
	Y_in_A = 2;
	DIR_A = 1;
	#FP;

	// Pressing BTN_A go to SEND_B state
	BTN_A = 1; 
	#FP;
	BTN_A = 0;

	// Take inputs Y_IN_B and BTN_B, Y_IN_B equal to Puck's Y position, go to SEND_A state
	#(20*FP);
	Y_in_B = 2; 
	#FP;
	BTN_B = 1;
    #FP; 
	BTN_B = 0;

	// Take inputs Y_IN_A and BTN_A, Y_IN_A equal to Puck's Y position, go to SEND_B state
	#(15*FP);
	Y_in_A = 0; 
	#FP;
	BTN_A = 1;
    #(2*FP); 
	BTN_A = 0;
	#(2*FP);

	// GOAL_B state, score (1-2)
	#(5*FP); 

	// HIT_A state, take inputs Y_IN_A and DIR_A 
	Y_in_A = 3;
	DIR_A = 0;
	#FP;

	// Pressing BTN_B go to SEND_A state
	BTN_A = 1; 
	#FP;
	BTN_A = 0;

	// Take inputs Y_IN_B and BTN_B, Y_IN_B equal to Puck's Y position, go to SEND_B state
	#(20*FP);
	Y_in_B = 3;
	DIR_B = 2; 
	#FP;
	BTN_B = 1;
	#FP; 
	BTN_B = 0;

	// Take inputs Y_IN_A and BTN_A, Y_IN_A equal to Puck's Y position, go to SEND_B state
	#(15*FP);
	Y_in_A = 1; 
	DIR_A = 1;
	#FP;
	BTN_A = 1;
	#FP; 
	BTN_A = 0;

	// Take inputs Y_IN_B and BTN_B, Y_IN_B equal to Puck's Y position, go to SEND_A state
	#(15*FP);
	Y_in_B = 3;
	#FP;
	BTN_B = 1;
	#FP; 
	BTN_B = 0;

	// Take inputs Y_IN_A and BTN_A, Y_IN_A equal to Puck's Y position, go to GOAL_B state
	#(15*FP);
	Y_in_A = 0; 
	#FP;
	BTN_A = 1;
	#(2*FP); 
	BTN_A = 0;
	#(2*FP);

	// GOAL_B state, score (1-3), game over
	#(5*FP);

    $display("Simulation finished.");
    $finish(); // Finish simulation.
end



endmodule
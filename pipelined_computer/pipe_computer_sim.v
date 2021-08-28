`timescale 1ps/1ps

module pipe_computer_sim;
	reg         resetn, clk;
	wire        mem_clk;
	wire [31:0] pc, inst, ealu, malu, walu;
	wire [4:0]  drn, ern, mrn, wrn;
	reg  [9:0]  sw;
	reg  [3:1]  key;
	wire [6:0]  hex5, hex4, hex3, hex2, hex1, hex0;
	wire [9:0]  led;

	pipeline_computer_01 pipe_computer_instance(resetn,clk,mem_clk,pc,inst,ealu,malu,walu,
		sw,key,hex5,hex4,hex3,hex2,hex1,hex0,led);

	initial begin // Generate clock.
		clk = 1;
		while (1)
			#2 clk = ~clk;
	end
	
	initial begin // Generate a reset signal at the start.
		resetn = 1;
		#1 resetn = 0;
		#5 resetn = 1;
		// while (1) begin // Reset and run pipe test again.
		// 	#400 resetn = 0;
		// 	#5   resetn = 1;
		// end
	end

	initial begin // Simulate switch changes.
		sw <= 10'b1010101010;
		//while (1)
			//#2400 sw = ~sw;
	end

	initial begin // Simulate key presses.
		key <= 3'b011;
		//while (1) begin
			//#800 key <= 3'b101; // key2 pressed, should change to sub mode
			//#800 key <= 3'b110; // key1 pressed, should change to xor mode
			//#800 key <= 3'b011; // key3 pressed, should change to add mode
		//end
	end
	
	initial
        begin
		  
          $display($time,"resetn=%b clock_50M=%b  mem_clk =%b", resetn, clk, mem_clk);
			 
			 # 12500 $display($time," out_port0 = %b  out_port1 = %b  out_port2 = %b  out_port3 = %b  out_port4 = %b  out_port5 = %b ", hex5,hex4,hex3,hex2,hex1,hex0 );

        end
endmodule
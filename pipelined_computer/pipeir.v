// IR 寄存器及 PC+4 寄存器
module pipeir (pc4,ins,wir,clk,clrn,dpc4,inst);
	input [31:0]	pc4,ins;
	input				wir,clk,clrn;
	output [31:0]	dpc4,inst;
	dffe32 pc_plus4 (pc4,clk,clrn,wir,dpc4);
	dffe32 instruction (ins,clk,clrn,wir,inst);
endmodule
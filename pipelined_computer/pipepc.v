// PC 寄存器，IF 阶段的寄存器
module pipepc(npc, wpc, clk, clrn, pc);
	input [31:0]	npc;
	input 			wpc, clk, clrn;
	output [31:0]	pc;
	dffe32pc program_counter (npc,clk,clrn,wpc,pc);
endmodule
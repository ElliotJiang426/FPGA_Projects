// IF 阶段的组合电路
module pipeif (pcsource, pc, bpc, rpc, jpc, npc, pc4, ins, imem_clk);
	input [31:0]	pc,bpc,rpc,jpc;
	input [1:0]		pcsource;
	input 			imem_clk;
	output [31:0]	npc,pc4,ins;
	
	assign pc4 = pc + 4;
	
	mux4x32 next_pc (pc4,bpc,rpc,jpc,pcsource,npc);
	pipeimem inst_mem (pc,ins,imem_clk);
endmodule
// 指令存储器，使用 pipeimem.mif 文件初始化
module pipeimem(a, inst, imem_clk);
	input [31:0]	a;
	input 			imem_clk;
	output [31:0]	inst;
	
	rom_1port irom(a[8:2], imem_clk, inst);
endmodule
// EXE 级的组合电路
module pipeexe (ealuc, ealuimm, ea, eb, eimm, eshift, ern0, epc4, ejal, ern, ealu);
	input [31:0]	ea,eb,eimm,epc4;
	input [4:0]		ern0;
	input [3:0]		ealuc;
	input 			ealuimm,eshift,ejal;
	output [31:0]	ealu;
	output [4:0]	ern;
	
	wire [31:0]		alua,alub,sa,ealu0,epc8;
	
	assign sa = {27'b0, eimm[10:6]};	// shift amount
	
	mux2x32 alu_ina (ea,sa,eshift,alua);
	mux2x32 alu_inb (eb,eimm,ealuimm,alub);
	mux2x32 save_pc8 (ealu0,epc8,ejal,ealu);
	
	assign epc8 = epc4 + 4;
	assign ern = ern0 | {5{ejal}};
	
	alu al_unit (alua,alub,ealuc,ealu0);
endmodule
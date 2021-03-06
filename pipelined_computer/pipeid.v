// ID 级组合电路
module pipeid (mwreg, mrn, ern, ewreg, em2reg, mm2reg, dpc4, inst, wrn,
					wdi, ealu, malu, mmo, wwreg, clk, clrn, bpc, jpc, pcsource,
					nostall, wreg, m2reg, wmem, aluc, aluimm, da, db, dimm, rn, shift, jal);
	input [31:0]	dpc4,inst,wdi,ealu,malu,mmo;
	input [4:0]		ern,mrn,wrn;
	input 			mwreg,ewreg,em2reg,mm2reg,wwreg;
	input				clk,clrn;
	output [31:0]	bpc,jpc,da,db,dimm;
	output [4:0]	rn;
	output [3:0]	aluc;
	output [1:0]	pcsource;
	output 			nostall,wreg,m2reg,wmem,aluimm,shift,jal;
	
	wire [5:0]		op,func;
	wire [4:0]		rs,rt,rd;
	wire [31:0]		qa,qb,br_offset;
	wire [15:0]		ext16,imm;
	wire [1:0]		fwda,fwdb;
	wire 				regrt,sext,rsrtequ,e;
	
	assign func = inst[5:0];
	assign op	= inst[31:26];
	assign rs	= inst[25:21];
	assign rt	= inst[20:16];
	assign rd	= inst[15:11];
	assign imm 	= inst[15:0];
	assign jpc	= {dpc4[31:28],inst[25:0],2'b00};
	
	pipeidcu cu (mwreg,mrn,ern,ewreg,em2reg,mm2reg,rsrtequ,func,
					 op,rs,rt,wreg,m2reg,wmem,aluc,regrt,aluimm,
					 fwda,fwdb,nostall,sext,pcsource,shift,jal);
	
	regfile rf (rs,rt,wdi,wrn,wwreg,~clk,clrn,qa,qb);
	mux2x5 des_reg_no (rd,rt,regrt,rn);
	mux4x32 alu_a (qa,ealu,malu,mmo,fwda,da);
	mux4x32 alu_b (qb,ealu,malu,mmo,fwdb,db);
	
	assign rsrtequ = (da == db); // rsrtequ = (a == b)
	assign e = sext & inst[15];
	assign ext16 = {16{e}};
	assign dimm = {ext16,imm};
	assign br_offset = {dimm[29:0],2'b00};
	assign bpc = dpc4 + br_offset;
endmodule
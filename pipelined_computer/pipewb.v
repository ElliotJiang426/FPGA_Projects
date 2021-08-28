// WB 级组合逻辑
module pipewb (walu, wmo, wm2reg, wdi);
	input				wm2reg;
	input [31:0]	walu,wmo;
	output [31:0]	wdi;
	
	mux2x32 select_write_data (walu, wmo, wm2reg, wdi);
endmodule
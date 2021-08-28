/////////////////////////////////////////////////////////////
//                                                         //
// School of Software of SJTU                              //
//                                                         //
/////////////////////////////////////////////////////////////

module sc_computer (resetn,clock,mem_clk,pc,inst,aluout,memout,imem_clk,dmem_clk,
	sw,key,hex5,hex4,hex3,hex2,hex1,hex0,led);
   
   input resetn,clock,mem_clk;
	input [9:0] sw;
	input [3:1] key;
   output [31:0] pc,inst,aluout,memout;
   output        imem_clk,dmem_clk;
	output [6:0]  hex5,hex4,hex3,hex2,hex1,hex0;
	output [9:0]  led;
   wire   [31:0] data;
   wire          wmem; // all these "wire"s are used to connect or interface the cpu,dmem,imem and so on.
   
   sc_cpu cpu (clock,resetn,inst,memout,pc,wmem,aluout,data);          // CPU module.
   sc_instmem  imem (pc,inst,clock,mem_clk,imem_clk);                  // instruction memory.
   sc_datamem  dmem (resetn,aluout,data,memout,wmem,clock,mem_clk,dmem_clk,
							sw,key,hex5,hex4,hex3,hex2,hex1,hex0,led); // data memory.

endmodule




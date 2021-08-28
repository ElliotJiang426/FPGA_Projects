//=============================================
//
// 璇Verilog HDL 浠ｇ爜锛屾槸鐢ㄤ簬瀵硅璁℃ā鍧楄繘琛屼豢鐪熸椂锛屽杈撳叆淇″彿鐨勬ā鎷熻緭鍏ュ€肩殑璁惧畾銆// 鍚﹀垯锛屽緟浠跨湡鐨勫璞℃ā鍧楋紝浼氬洜涓虹己灏戣緭鍏ヤ俊鍙凤紝鑰屸€滀笉鐭ユ墍鎺€濄€// 璇ユ枃浠跺彲璁惧畾鑻ュ共瀵圭洰鏍囪璁″姛鑳借繘琛屽悇绉嶆儏鍐典笅娴嬭瘯鐨勮緭鍏ョ敤渚嬶紝浠ュ垽鏂嚜宸辩殑鍔熻兘璁捐鏄惁姝ｇ‘銆//
// 瀵逛簬CPU璁捐鏉ヨ锛屽熀鏈緭鍏ラ噺鍙湁锛氬浣嶄俊鍙枫€佹椂閽熶俊鍙枫€//
// 瀵逛簬甯/O璁捐锛屽垯闇€瑕佽瀹氬悇杈撳叆淇″彿鍊笺€//
//
// =============================================


// `timescale 10ns/10ns            // 浠跨湡鏃堕棿鍗曚綅/鏃堕棿绮惧害
`timescale 1ps/1ps            // 浠跨湡鏃堕棿鍗曚綅/鏃堕棿绮惧害

//
// 锛锛変豢鐪熸椂闂村崟浣鏃堕棿绮惧害锛氭暟瀛楀繀椤讳负1銆0銆00
// 锛锛変豢鐪熸椂闂村崟浣嶏細妯″潡浠跨湡鏃堕棿鍜屽欢鏃剁殑鍩哄噯鍗曚綅
// 锛锛変豢鐪熸椂闂寸簿搴︼細妯″潡浠跨湡鏃堕棿鍜屽欢鏃剁殑绮剧‘绋嬪害锛屽繀椤诲皬浜庢垨绛変簬浠跨湡鍗曚綅鏃堕棿
//
//      鏃堕棿鍗曚綅锛歴/绉掋€乵s/姣銆乽s/寰銆乶s/绾崇銆乸s/鐨銆乫s/椋炵锛0璐5娆℃柟锛夈€

module sc_computer_sim;

    reg           resetn_sim;
    reg           clock_50M_sim;
	 reg           mem_clk_sim;
	 reg    [31:0] in_port0_sim;
	 reg    [31:0] in_port1_sim;
	 reg    [9:0] 	sw_sim;
	 reg    [3:1]  key_sim;	
	 

    wire   [6:0]  hex0_sim,hex1_sim,hex2_sim,hex3_sim,hex4_sim,hex5_sim;
	 wire   [9:0]  led_sim;
	 
	       
//	 wire   [31:0]  in_port0_sim,in_port1_sim;
	 
	 wire   [31:0]  pc_sim,inst_sim,aluout_sim,memout_sim;
    wire           imem_clk_sim,dmem_clk_sim;
    
    wire   [31:0]  mem_dataout_sim;            // to check data_mem output
    wire   [31:0]  data_sim;
    wire   [31:0]  io_read_data_sim;
   
    wire           wmem_sim;   // connect the cpu and dmem. 

    sc_computer    sc_computer_instance (resetn_sim,clock_50M_sim,mem_clk_sim,pc_sim,inst_sim,aluout_sim,memout_sim,
	                                      imem_clk_sim,dmem_clk_sim,sw_sim,key_sim,hex5_sim,hex4_sim,
													  hex3_sim,hex2_sim,hex1_sim,hex0_sim,led_sim);

// module sc_computer (resetn,clock,mem_clk,pc,inst,aluout,memout,imem_clk,dmem_clk,out_port0,out_port1,in_port0,in_port1,mem_dataout,data,io_read_data);

/* input resetn,clock,mem_clk;
   
   input [31:0] in_port0,in_port1;
   
   output [31:0] pc,inst,aluout,memout;
   output        imem_clk,dmem_clk;
   output [31:0] out_port0,out_port1;
   output [31:0] mem_dataout;            // to check data_mem output
   output [31:0] data;
   output [31:0] io_read_data;
   
   wire   [31:0] data;
   wire          wmem;   // connect the cpu and dmem. 
*/




										
						
	 initial
        begin
            clock_50M_sim = 1;
            while (1)
                #2  clock_50M_sim = ~clock_50M_sim;
        end

	   
	 initial
        begin
            mem_clk_sim = 1;
            while (1)
                #1  mem_clk_sim = ~ mem_clk_sim;
        end

	   	  
		  
		  
	 initial
        begin
            resetn_sim = 0;            // 浣庣數骞虫寔缁0涓椂闂村崟浣嶏紝鍚庝竴鐩翠负1銆            
				while (1)
                #5 resetn_sim = 1;
        end
	 
	 initial
	     begin
		      sw_sim = 10'b0001100110;
				key_sim = 4'b0;
		  end



	 
	 	  
		  
    initial
        begin
		  
          $display($time,"resetn=%b clock_50M=%b  mem_clk =%b", resetn_sim, clock_50M_sim, mem_clk_sim);
			 
			 # 12500 $display($time," out_port0 = %b  out_port1 = %b  out_port2 = %b  out_port3 = %b  out_port4 = %b  out_port5 = %b ", hex5_sim,hex4_sim,hex3_sim,hex2_sim,hex1_sim,hex0_sim );

        end

endmodule 


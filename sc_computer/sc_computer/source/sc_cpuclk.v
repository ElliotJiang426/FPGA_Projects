// 把输入的 memclk 转换为两倍周期的 cpu clock
module clock_2T(inclk, outclk);
	input inclk;
	output reg outclk;
	
	initial begin
		outclk <= 0;
	end
	
	always @(posedge inclk)
		outclk <= ~outclk;
endmodule

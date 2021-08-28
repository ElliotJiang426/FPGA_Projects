// 将板载 50MHz 的时钟转换成需要的 memclk 时钟
module clock_mem(clk_50M, resetn, memclk);
	input clk_50M, resetn;
	output reg memclk;
	reg [31:0] counter;
	parameter N = 2;
	
	initial begin
		counter <= 0;
		memclk <= 0;
	end
	
	always @(posedge clk_50M or negedge resetn) begin
		if (!resetn) begin
			counter <= 0;
			memclk <= 0;
		end
		else begin
			if (counter >= N / 2 - 1) begin
				counter <= 0;
				memclk <= ~memclk;
			end
			else
				counter <= counter + 1;
		end
	end
endmodule

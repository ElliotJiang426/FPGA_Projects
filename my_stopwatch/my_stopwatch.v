module stopwatch_01(clk,key_reset,key_start_pause,key_display_stop,key_display_restart,
	// 时钟输入 + 3 个按键；按键按下为 0。板上利用施密特触发器做了一定消抖，效果待测试。
							hex0,hex1,hex2,hex3,hex4,hex5,
	// 板上的 6 个 7 段数码管，每个数码管有 7 位控制信号。
							led
							); 
	// LED 发光二极管指示灯，用于指示/测试程序按键状态，若需要，可增加。高电平亮。
	
	input clk,key_reset,key_start_pause,key_display_stop,key_display_restart;
	output [6:0] hex0,hex1,hex2,hex3,hex4,hex5;
	output [9:0] led;
	
	reg [18:0] time_counter;
	// 累计计时
	reg display_work = 1; 
	// 显示刷新，即显示寄存器的值 实时更新为计数寄存器的值。
	reg counter_work = 0; 
	// 计数（计时）工作状态，由按键“计时/暂停”控制。
	parameter DELAY_TIME = 10000000; 
	// 定义一个常量参数。 10000000->200ms；
	parameter MAX_TIME = 360000 - 1;
	// 定义一个常量参数为最大可显示时间；
	
	// 定义 6 个显示数据（变量）寄存器：
	reg [3:0] minute_display_high;
	reg [3:0] minute_display_low;
	reg [3:0] second_display_high;
	reg [3:0] second_display_low;
	reg [3:0] msecond_display_high;
	reg [3:0] msecond_display_low;
	
	// 定义 6 个计时数据（变量）寄存器：
	reg [3:0] minute_counter_high;
	reg [3:0] minute_counter_low;
	reg [3:0] second_counter_high;
	reg [3:0] second_counter_low;
	reg [3:0] msecond_counter_high;
	reg [3:0] msecond_counter_low;
	 
	reg [31:0] counter_50M; // 计时用计数器， 每个 50MHz 的 clock 为 20ns。
	// DE1-SOC 板上有 4 个时钟， 都为 50MHz，所以需要 500000 次 20ns 之后，才是 10ms。
	
	reg [31:0] counter_reset; // 按键状态时间计数器
	reg [31:0] counter_start; // 按键状态时间计数器
	reg [31:0] counter_display; // 按键状态时间计数器
	reg [9:0] led;
	
	// 记录 key 的上一个值
	reg key_reset_last;
	reg key_start_pause_last;
	reg key_display_restart_last;
	reg key_display_stop_last;
	
	// sevenseg 模块为 4 位的 BCD 码至 7 段 LED 的译码器，
	// 下面实例化 6 个 LED 数码管的各自译码器。
	sevenseg LED8_minute_display_high ( minute_display_high, hex5 );
	sevenseg LED8_minute_display_low ( minute_display_low, hex4 );
	sevenseg LED8_second_display_high( second_display_high, hex3 );
	sevenseg LED8_second_display_low ( second_display_low, hex2 );
	sevenseg LED8_msecond_display_high( msecond_display_high, hex1 );
	sevenseg LED8_msecond_display_low ( msecond_display_low, hex0 );
	 
	always @ (posedge clk) // 每一个时钟上升沿开始触发下面的逻辑，
	// 进行计时后各部分的刷新工作
	begin
		if (counter_50M < 500000) begin
			// 没有到 10ms
			counter_50M <= counter_50M + 1;
		end
		else begin
			// 到达 10ms
			counter_50M <= 0;
	
			// 按下 reset 按钮，重置所有数据
			if (!key_reset && key_reset_last != key_reset) begin
				counter_work <= 0;
				display_work <= 1;
				time_counter <= 0;
				minute_counter_high <= 0;
				minute_counter_low <= 0;
				second_counter_high <= 0;
				second_counter_low <= 0;
				msecond_counter_high <= 0;
				msecond_counter_low <= 0;
				minute_display_high <= 0;
				minute_display_low <= 0;
				second_display_high <= 0;
				second_display_low <= 0;
				msecond_display_high <= 0;
				msecond_display_low <= 0;
				led = 0;
			end
			else begin
				if (counter_work) begin
					if (time_counter <= MAX_TIME) begin
						time_counter <= time_counter + 1;
					end
					else
						time_counter <= 0;
					
					minute_counter_high <= time_counter / 60000;
					minute_counter_low <= time_counter / 6000 % 10;
					second_counter_high <= time_counter % 6000 / 1000;
					second_counter_low <= time_counter / 100 % 10;
					msecond_counter_high <= time_counter % 100 / 10;
					msecond_counter_low <= time_counter % 10;
					
					// 计时期间 LED 持续闪烁
					led = (1 << (9 - time_counter / 100 % 10));
					
					// 如果显示更新开启
					if (display_work) begin
						minute_display_high <= minute_counter_high;
						minute_display_low <= minute_counter_low;
						second_display_high <= second_counter_high;
						second_display_low <= second_counter_low;
						msecond_display_high <= msecond_counter_high;
						msecond_display_low <= msecond_counter_low;
						
						// // 按下 “显示暂停” 暂停到当前时间
						if (!key_display_stop && key_display_stop_last != key_display_stop) begin
							display_work <= ~display_work;
							key_display_stop_last <= key_display_stop;
						end
					end
					else begin
						// 按下 “显示暂停” 更新为最新时间，仍然保持暂停显示
						if (!key_display_stop && key_display_stop_last != key_display_stop) begin
							minute_display_high <= minute_counter_high;
							minute_display_low <= minute_counter_low;
							second_display_high <= second_counter_high;
							second_display_low <= second_counter_low;
							msecond_display_high <= msecond_counter_high;
							msecond_display_low <= msecond_counter_low;
						end
						// 按下 “显示重启” 显示开始变化
						if (!key_display_restart && key_display_restart_last != key_display_restart) begin
							display_work <= ~display_work;
						end
					end
				end
				
				// 按下 “开始/暂停” 按钮
				if (!key_start_pause && key_start_pause_last != key_start_pause) begin
					counter_work <= ~counter_work;
				end
			end
			key_start_pause_last <= key_start_pause;
			key_display_restart_last <= key_display_restart;
			key_display_stop_last <= key_display_stop;
			key_reset_last <= key_reset;
		end
	end
endmodule

// 4bit 的 BCD 码至 7 段 LED 数码管译码器模块
// 可供实例化共 6 个显示译码模块
module sevenseg (data, ledsegments); 
	input [3:0] data;
	output ledsegments;
	reg [6:0] ledsegments;
	always @ (*)
		 case(data)
		 // gfe_dcba // 7 段 LED 数码管的位段编号
		 // 654_3210 // DE1-SOC 板上的信号位编号
		 0: ledsegments = 7'b100_0000; // DE1-SOC 板上的数码管为共阳极接法。
		 1: ledsegments = 7'b111_1001;
		 2: ledsegments = 7'b010_0100;
		 3: ledsegments = 7'b011_0000;
		 4: ledsegments = 7'b001_1001;
		 5: ledsegments = 7'b001_0010;
		 6: ledsegments = 7'b000_0010;
		 7: ledsegments = 7'b111_1000;
		 8: ledsegments = 7'b000_0000;
		 9: ledsegments = 7'b001_0000; 
		 default: ledsegments = 7'b111_1111; // 其它值时全灭。
	endcase 
endmodule

// 按键消抖模块
module debouncer(clk, keyin, keyout);
	input clk, keyin;
	output reg keyout;
	reg keypast;
	reg [31:0] counter_50M; // 计时用计数器， 每个 50MHz 的 clock 为 20ns。
	always @(posedge clk) begin
		if (counter_50M < 500000) begin
			// 没有到 10ms
			counter_50M <= counter_50M + 1;
		end
		else begin
			// 到达 10ms
			counter_50M <= 0;
			if (keypast == keyin) 
				keyout <= keyin;
			keypast <= keyin;
		end
	end
endmodule

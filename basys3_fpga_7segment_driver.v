`timescale 1ms / 1ns

module led_driver(
	input clk_100mhz, reset,
	input [15:0] bcd_data_ip,
	output reg [3:0] anode_n,
	output reg [7:0] cathode_n
);
	localparam S_DIGIT_0 = 8'b11000000; // dot g f e d c b a
    localparam S_DIGIT_1 = 8'b11111001; 
    localparam S_DIGIT_2 = 8'b10100100; 
    localparam S_DIGIT_3 = 8'b10110000; 
    localparam S_DIGIT_4 = 8'b10011001; 
    localparam S_DIGIT_5 = 8'b10010010; 
    localparam S_DIGIT_6 = 8'b10000010; 
    localparam S_DIGIT_7 = 8'b11111000; 
    localparam S_DIGIT_8 = 8'b10000000; 
    localparam S_DIGIT_9 = 8'b10010000; 
	localparam BLANK   = 8'b11111111;
	
	reg clk_1khz;
	reg [$clog2(50000)-1 : 0] divider;
	reg [1:0]cnt;
	reg [31:0]data_ip;
	///////////////////	BCD_2_Seven_Segment	////////////////////
	always @(*) begin
		case (bcd_data_ip[3:0])
            4'b0000: data_ip[7:0] = S_DIGIT_0; // 0
            4'b0001: data_ip[7:0] = S_DIGIT_1; // 1
            4'b0010: data_ip[7:0] = S_DIGIT_2; // 2
            4'b0011: data_ip[7:0] = S_DIGIT_3; // 3
            4'b0100: data_ip[7:0] = S_DIGIT_4; // 4
            4'b0101: data_ip[7:0] = S_DIGIT_5; // 5
            4'b0110: data_ip[7:0] = S_DIGIT_6; // 6
            4'b0111: data_ip[7:0] = S_DIGIT_7; // 7
            4'b1000: data_ip[7:0] = S_DIGIT_8; // 8
            4'b1001: data_ip[7:0] = S_DIGIT_9; // 9
            default: data_ip[7:0] = BLANK;   // For BCD values 10-15, display blank
        endcase
		case (bcd_data_ip[7:4])
            4'b0000: data_ip[15:8] = S_DIGIT_0; // 0
            4'b0001: data_ip[15:8] = S_DIGIT_1; // 1
            4'b0010: data_ip[15:8] = S_DIGIT_2; // 2
            4'b0011: data_ip[15:8] = S_DIGIT_3; // 3
            4'b0100: data_ip[15:8] = S_DIGIT_4; // 4
            4'b0101: data_ip[15:8] = S_DIGIT_5; // 5
            4'b0110: data_ip[15:8] = S_DIGIT_6; // 6
            4'b0111: data_ip[15:8] = S_DIGIT_7; // 7
            4'b1000: data_ip[15:8] = S_DIGIT_8; // 8
            4'b1001: data_ip[15:8] = S_DIGIT_9; // 9
            default: data_ip[15:8] = BLANK;   // For BCD values 10-15, display blank
        endcase
		case (bcd_data_ip[11:8])
            4'b0000: data_ip[23:16] = S_DIGIT_0; // 0
            4'b0001: data_ip[23:16] = S_DIGIT_1; // 1
            4'b0010: data_ip[23:16] = S_DIGIT_2; // 2
            4'b0011: data_ip[23:16] = S_DIGIT_3; // 3
            4'b0100: data_ip[23:16] = S_DIGIT_4; // 4
            4'b0101: data_ip[23:16] = S_DIGIT_5; // 5
            4'b0110: data_ip[23:16] = S_DIGIT_6; // 6
            4'b0111: data_ip[23:16] = S_DIGIT_7; // 7
            4'b1000: data_ip[23:16] = S_DIGIT_8; // 8
            4'b1001: data_ip[23:16] = S_DIGIT_9; // 9
            default: data_ip[23:16] = BLANK;   // For BCD values 10-15, display blank
        endcase
		case (bcd_data_ip[15:12])
            4'b0000: data_ip[31:24] = S_DIGIT_0; // 0
            4'b0001: data_ip[31:24] = S_DIGIT_1; // 1
            4'b0010: data_ip[31:24] = S_DIGIT_2; // 2
            4'b0011: data_ip[31:24] = S_DIGIT_3; // 3
            4'b0100: data_ip[31:24] = S_DIGIT_4; // 4
            4'b0101: data_ip[31:24] = S_DIGIT_5; // 5
            4'b0110: data_ip[31:24] = S_DIGIT_6; // 6
            4'b0111: data_ip[31:24] = S_DIGIT_7; // 7
            4'b1000: data_ip[31:24] = S_DIGIT_8; // 8
            4'b1001: data_ip[31:24] = S_DIGIT_9; // 9
            default: data_ip[31:24] = BLANK;   // For BCD values 10-15, display blank
        endcase
	end
	///////////////////Display_Refresh_Circuit//////////////////
	always @(posedge clk_1khz) begin
		if(reset) begin
			anode_n <= 4'b1110;
			cathode_n <= data_ip[7:0];
			cnt <= 1;
		end
		else begin
			cnt <= cnt + 1;
			anode_n <= {anode_n[2:0], anode_n[3]};
			if(cnt == 0)
				cathode_n <= data_ip[7:0];
			else if(cnt == 1)
				cathode_n <= data_ip[15:8];
			else if(cnt == 2)
				cathode_n <= data_ip[23:16];
			else if(cnt == 3)
				cathode_n <= data_ip[31:24];
			else 
				cathode_n <= 0;
		end
	end
	////////////////////   1KHz_CLK_Generator	////////////////
	always @(posedge clk_100mhz) begin
		/*if(reset) begin
			clk_1khz <= 0;
			divider <= 0;
		end*/
		if (divider == 49999) begin
			clk_1khz <= ~clk_1khz;
			divider <= 0;
		end
		else begin
			clk_1khz <= clk_1khz;
			divider <= divider + 1;
		end
	end
endmodule
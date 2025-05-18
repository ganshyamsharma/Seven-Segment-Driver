`timescale 1ms / 1ns

module led_driver(
	input i_clk_100mhz, i_reset,
	input [15:0] i_bcd_data,
	output reg [3:0] o_digit_anodes_n,
	output reg [7:0] o_digit_cathode_n
);
	localparam S_DIGIT_0 = 8'b11000000;		// dot g f e d c b a
    localparam S_DIGIT_1 = 8'b11111001; 
    localparam S_DIGIT_2 = 8'b10100100; 
    localparam S_DIGIT_3 = 8'b10110000; 
    localparam S_DIGIT_4 = 8'b10011001; 
    localparam S_DIGIT_5 = 8'b10010010; 
    localparam S_DIGIT_6 = 8'b10000010; 
    localparam S_DIGIT_7 = 8'b11111000; 
    localparam S_DIGIT_8 = 8'b10000000; 
    localparam S_DIGIT_9 = 8'b10010000; 
	localparam BLANK = 8'b11111111;
	
	reg r_clk_1khz;
	reg [$clog2(50000)-1 : 0] r_divider;
	reg [1:0] r_cnt;
	reg [31:0] r_7seg_code;
	///////////////////	BCD_2_Seven_Segment	////////////////////
	always @(*) begin
		case (i_bcd_data[3:0])
            4'b0000: r_7seg_code[7:0] = S_DIGIT_0; // 0
            4'b0001: r_7seg_code[7:0] = S_DIGIT_1; // 1
            4'b0010: r_7seg_code[7:0] = S_DIGIT_2; // 2
            4'b0011: r_7seg_code[7:0] = S_DIGIT_3; // 3
            4'b0100: r_7seg_code[7:0] = S_DIGIT_4; // 4
            4'b0101: r_7seg_code[7:0] = S_DIGIT_5; // 5
            4'b0110: r_7seg_code[7:0] = S_DIGIT_6; // 6
            4'b0111: r_7seg_code[7:0] = S_DIGIT_7; // 7
            4'b1000: r_7seg_code[7:0] = S_DIGIT_8; // 8
            4'b1001: r_7seg_code[7:0] = S_DIGIT_9; // 9
            default: r_7seg_code[7:0] = BLANK;   // For BCD values 10-15, display blank
        endcase
		case (i_bcd_data[7:4])
            4'b0000: r_7seg_code[15:8] = S_DIGIT_0; // 0
            4'b0001: r_7seg_code[15:8] = S_DIGIT_1; // 1
            4'b0010: r_7seg_code[15:8] = S_DIGIT_2; // 2
            4'b0011: r_7seg_code[15:8] = S_DIGIT_3; // 3
            4'b0100: r_7seg_code[15:8] = S_DIGIT_4; // 4
            4'b0101: r_7seg_code[15:8] = S_DIGIT_5; // 5
            4'b0110: r_7seg_code[15:8] = S_DIGIT_6; // 6
            4'b0111: r_7seg_code[15:8] = S_DIGIT_7; // 7
            4'b1000: r_7seg_code[15:8] = S_DIGIT_8; // 8
            4'b1001: r_7seg_code[15:8] = S_DIGIT_9; // 9
            default: r_7seg_code[15:8] = BLANK;   // 
        endcase
		case (i_bcd_data[11:8])
            4'b0000: r_7seg_code[23:16] = S_DIGIT_0; // 0
            4'b0001: r_7seg_code[23:16] = S_DIGIT_1; // 1
            4'b0010: r_7seg_code[23:16] = S_DIGIT_2; // 2
            4'b0011: r_7seg_code[23:16] = S_DIGIT_3; // 3
            4'b0100: r_7seg_code[23:16] = S_DIGIT_4; // 4
            4'b0101: r_7seg_code[23:16] = S_DIGIT_5; // 5
            4'b0110: r_7seg_code[23:16] = S_DIGIT_6; // 6
            4'b0111: r_7seg_code[23:16] = S_DIGIT_7; // 7
            4'b1000: r_7seg_code[23:16] = S_DIGIT_8; // 8
            4'b1001: r_7seg_code[23:16] = S_DIGIT_9; // 9
            default: r_7seg_code[23:16] = BLANK;   // 
        endcase
		case (i_bcd_data[15:12])
            4'b0000: r_7seg_code[31:24] = S_DIGIT_0; // 0
            4'b0001: r_7seg_code[31:24] = S_DIGIT_1; // 1
            4'b0010: r_7seg_code[31:24] = S_DIGIT_2; // 2
            4'b0011: r_7seg_code[31:24] = S_DIGIT_3; // 3
            4'b0100: r_7seg_code[31:24] = S_DIGIT_4; // 4
            4'b0101: r_7seg_code[31:24] = S_DIGIT_5; // 5
            4'b0110: r_7seg_code[31:24] = S_DIGIT_6; // 6
            4'b0111: r_7seg_code[31:24] = S_DIGIT_7; // 7
            4'b1000: r_7seg_code[31:24] = S_DIGIT_8; // 8
            4'b1001: r_7seg_code[31:24] = S_DIGIT_9; // 9
            default: r_7seg_code[31:24] = BLANK;   // 
        endcase
	end
	///////////////////Display_Refresh_Circuit//////////////////
	always @(posedge r_clk_1khz) begin
		if(i_reset) begin
			o_digit_anodes_n <= 4'b1110;
			o_digit_cathode_n <= r_7seg_code[7:0];
			r_cnt <= 1;
		end
		else begin
			r_cnt <= r_cnt + 1;
			o_digit_anodes_n <= {o_digit_anodes_n[2:0], o_digit_anodes_n[3]};
			if(r_cnt == 0)
				o_digit_cathode_n <= r_7seg_code[7:0];
			else if(r_cnt == 1)
				o_digit_cathode_n <= r_7seg_code[15:8];
			else if(r_cnt == 2)
				o_digit_cathode_n <= r_7seg_code[23:16];
			else if(r_cnt == 3)
				o_digit_cathode_n <= r_7seg_code[31:24];
			else 
				o_digit_cathode_n <= 0;
		end
	end
	////////////////////   1KHz_CLK_Generator	////////////////
	always @(posedge i_clk_100mhz) begin
		/*if(i_reset) begin
			r_clk_1khz <= 0;
			r_divider <= 0;
		end*/
		if (r_divider == 49999) begin
			r_clk_1khz <= ~r_clk_1khz;
			r_divider <= 0;
		end
		else begin
			r_clk_1khz <= r_clk_1khz;
			r_divider <= r_divider + 1;
		end
	end
endmodule
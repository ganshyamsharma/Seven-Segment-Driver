///////////////////////	TEST BENCH	/////////////////////

`timescale 1ms / 1ns

module tb();
	reg clk_tb, reset_tb;
	reg [15:0] bcd_ip_tb = 16'b1001_0101_0011_1000;
	wire [3:0] anode_n_tb;
	wire [7:0] cathode_n_tb;
	
	always #0.000005 clk_tb = ~clk_tb;
	initial begin
		reset_tb = 1;
		clk_tb = 0;
		#1
		reset_tb = 0;
	end
	led_driver uut0(clk_tb, reset_tb, bcd_ip_tb, anode_n_tb, cathode_n_tb);
endmodule
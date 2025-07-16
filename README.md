# BCD to 7 segment code converter
This code converts a 4 digit (16 bit) BCD number to corresponding 7 segment code. The converted code is used to drive 4 seven segment leds sharing common cathodes.
A scanning display controller circuit operating at 1KHz is used to display four digits on the display. The anodes are driven using pnp transistors hence active low.
The code is tested on Digilent Basys-3 board.
## I/O Description
- i_clk: 			Input clock
- i_reset: 			Reset input to reset the conversion process
- i_bcd_data: 		Input, 16 bit BCD data to convert/display
- o_digit_anodes_n:	Active low anode outputs for each display
- o_digit_cathode_n:Shared common cathode outputs for each display

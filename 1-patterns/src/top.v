module top (
    input XTAL_IN,       // 24 MHz
    output [4:0] LCD_R,
    output [5:0] LCD_G,
    output [4:0] LCD_B,
    output LCD_HSYNC,
    output LCD_VSYNC,
    output LCD_CLK,
    output LCD_DEN
);


Gowin_rPLL pll(
    .clkin     (XTAL_IN),      // input clkin 24MHz
    .clkout    (),             // output clkout
    .clkoutd   (LCD_CLK)       // divided output clock
);

wire [8:0] x;
wire [8:0] y;

hsync hsync(
    .i_clk     (LCD_CLK),    // counter clock
    .o_hsync   (LCD_HSYNC),  // horizontal sync pulse
    .o_hde     (hde),        // horizontal signal in active zone
    .o_x       (x)           // x pixel position
);

vsync vsync(
    .i_clk     (LCD_HSYNC),  // counter clock
    .o_vsync   (LCD_VSYNC),  // vertical sync pulse
    .o_vde     (vde),        // vertical signal in active zone
    .o_y       (y)           // y pixel position
);

assign LCD_DEN = hde & vde;

assign LCD_R = 5'b00000;
assign LCD_G = 6'b000000;
assign LCD_B = 5'b10000;

endmodule
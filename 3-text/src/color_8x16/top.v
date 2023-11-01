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

wire false = 1'b0;
wire true = 1'b1;

Gowin_rPLL pll(
    .clkin     (XTAL_IN),      // input clkin 24MHz
    .clkout    (),             // output clkout
    .clkoutd   (LCD_CLK)       // divided output clock
);

wire [8:0] x;
wire [8:0] y;
wire hde;
wire vde;

// Generate H/V signals (on time)
wire hsync_timed;
wire vsync_timed;
wire enable_timed = hde & vde;

hsync hsync(
    .i_clk     (LCD_CLK),    // counter clock
    .o_hsync   (hsync_timed),// horizontal sync pulse
    .o_hde     (hde),        // horizontal signal in active zone
    .o_x       (x)           // x pixel position
);

vsync vsync(
    .i_clk     (LCD_HSYNC),  // counter clock
    .o_vsync   (vsync_timed),// vertical sync pulse
    .o_vde     (vde),        // vertical signal in active zone
    .o_y       (y)           // y pixel position
);

// Delay H/V signals 
wire hsync_delayed;
wire vsync_delayed;
wire enable_delayed;

delaybit_2tic delay_h(
    .clk  (LCD_CLK),
    .in   (hsync_timed),
    .out  (hsync_delayed)
);

delaybit_2tic delay_v(
    .clk  (LCD_CLK),
    .in   (vsync_timed),
    .out  (vsync_delayed)
);

delaybit_2tic delay_en(
    .clk  (LCD_CLK),
    .in   (enable_timed),
    .out  (enable_delayed)
);

assign LCD_HSYNC = hsync_delayed;
assign LCD_VSYNC = vsync_delayed;
assign LCD_DEN   = enable_delayed;


/*************************************
/*  Part III: Text
/*************************************/

wire [7:0]  chnum;
wire [7:0]  chatt;
wire [5:0]  x_cell     = x[8:3];  // 60 cols
wire [4:0]  y_cell     = y[8:4];  // 17 rows
wire [10:0] video_addr = {y_cell, x_cell};

// Character buffer
charbuf_color_64x32 charbuf_color_64x32(
    // A port: write
    .ada       (11'b0),      //input [10:0] A address
    .din       (16'b0),      //input [15:0] Data in
    .clka      (LCD_CLK),    //input clock for A port
    .cea       (false),      //input clock enable for A
    .reseta    (false),      //input reset for A

    // B port: read
    .adb       (video_addr), //input [10:0] B address
    .dout      ({chatt, chnum}),    //output [15:0] Data out
    .clkb      (LCD_CLK),    //input clock for B port
    .ceb       (true),       //input clock enable for B
    .resetb    (false),      //input reset for B

    // Global
    .oce       (true)        //input Output Clock Enable (not used in bypass mode)
);

wire pxon;   // pixel is ON/OFF

wire [2:0] x_char = x[2:0];     // x position inside char
wire [3:0] y_char = y[3:0];     // y position inside char (changed 2 to 3)
wire [2:0] x_char_delayed;
wire [3:0] y_char_delayed;

delayvector3_1tic delay_xcell(
    .clk  (LCD_CLK),
    .in   (x_char),
    .out  (x_char_delayed)
);

delayvector4_1tic delay_ycell(
    .clk  (LCD_CLK),
    .in   (y_char),
    .out  (y_char_delayed)
);


// 256 chars, 16 rows, 8 cols => 8+4+3 = 15 bits
wire [14:0] rom_addr = {chnum, y_char_delayed, x_char_delayed};

// Character generator, monochrome, 8x16 font
rom_font_1bit_8x16 rom_font_1bit_8x16(
    .ad       (rom_addr), // [14:0] address
    .clk      (LCD_CLK),
    .dout     (pxon),     // output is ON/OFF
    .oce      (true),     // output enable
    .ce       (true),     // chip enable
    .reset    (false)
);

reg [7:0] chatt_delayed;
always @(posedge LCD_CLK)
    chatt_delayed <= chatt;

// Color module
color color (
    .i_attr   (chatt_delayed), // Color attribute. irgb back (4b), irgb fore (4b)
    .i_fg     (pxon),          // pixel active (foreground color) vs background color
    .o_red    (LCD_R),
    .o_green  (LCD_G),
    .o_blue   (LCD_B)
);

endmodule

/*
This is the text engine. 
This module renders the content of the video memory and drives the LCD lines
to create the text.
*/
module text (
    input i_clk,                    // Clock (12 MHz)

    // VRAM handler
    input  [7:0]    i_char_data,    // get the character data (monochrome)
    output [10:0]   o_video_addr,   // VRAM address

    // LCD signals
    output          o_pxon,         // Monochrome pixel can be on/off
    output          o_LCD_HSYNC,    // LCD horizontal sync
    output          o_LCD_VSYNC,    // LCD vertical sync
    output          o_LCD_CLK,      // LCD clock
    output          o_LCD_DEN       // LCD data enable
);


wire false = 1'b0;
wire true = 1'b1;

// Coordinates
wire [8:0] x;
wire [8:0] y;
wire hde;
wire vde;

// Generate H/V signals (on time)
wire hsync_timed;
wire vsync_timed;
wire enable_timed = hde & vde;

hsync hsync(
    .i_clk     (i_clk),      // counter clock
    .o_hsync   (hsync_timed),// horizontal sync pulse
    .o_hde     (hde),        // horizontal signal in active zone
    .o_x       (x)           // x pixel position
);

vsync vsync(
    .i_clk     (hsync_timed),// counter clock
    .o_vsync   (vsync_timed),// vertical sync pulse
    .o_vde     (vde),        // vertical signal in active zone
    .o_y       (y)           // y pixel position
);

// Delay H/V signals 
wire hsync_delayed;
wire vsync_delayed;
wire enable_delayed;

delaybit_2tic delay_h(
    .clk  (i_clk),
    .in   (hsync_timed),
    .out  (hsync_delayed)
);

delaybit_2tic delay_v(
    .clk  (i_clk),
    .in   (vsync_timed),
    .out  (vsync_delayed)
);

delaybit_2tic delay_en(
    .clk  (i_clk),
    .in   (enable_timed),
    .out  (enable_delayed)
);

assign o_LCD_HSYNC = hsync_delayed;
assign o_LCD_VSYNC = vsync_delayed;
assign o_LCD_DEN   = enable_delayed;
assign o_LCD_CLK   = i_clk;

/*************************************
/*  Part III: Text
/*************************************/

wire [5:0]  x_cell       = x[8:3];  // 60 cols
wire [4:0]  y_cell       = y[8:4];  // 17 rows
assign o_video_addr = {y_cell, x_cell};

wire [2:0] x_char = x[2:0];     // x position inside char
wire [3:0] y_char = y[3:0];     // y position inside char (changed 2 to 3)
wire [2:0] x_char_delayed;
wire [3:0] y_char_delayed;

delayvector3_1tic delay_xcell(
    .clk  (i_clk),
    .in   (x_char),
    .out  (x_char_delayed)
);

delayvector4_1tic delay_ycell(
    .clk  (i_clk),
    .in   (y_char),
    .out  (y_char_delayed)
);

// 256 chars, 16 rows, 8 cols => 8+4+3 = 15 bits
wire [14:0] rom_addr = {i_char_data, y_char_delayed, x_char_delayed};

// Character generator, monochrome, 8x16 font
rom_font_1bit_8x16 rom_font_1bit_8x16(
    .ad       (rom_addr), // [14:0] address
    .clk      (i_clk),
    .dout     (o_pxon),   // output is ON/OFF
    .oce      (true),     // output enable
    .ce       (true),     // chip enable
    .reset    (false)
);

endmodule

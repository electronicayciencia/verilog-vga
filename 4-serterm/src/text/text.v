/*
This module creates the text engine and instanciate the video memory.
*/
module text (
    input i_clk,       // 24 MHz
    // VRAM write port
    input [10:0]    i_vram_addr,
    input  [7:0]    i_vram_data,
    input           i_vram_ce,
    // LCD signals
    output [4:0]    o_LCD_R,
    output [5:0]    o_LCD_G,
    output [4:0]    o_LCD_B,
    output          o_LCD_HSYNC,
    output          o_LCD_VSYNC,
    output          o_LCD_CLK,
    output          o_LCD_DEN
);


wire false = 1'b0;
wire true = 1'b1;

// Let LCD clock be 24/2 = 12MHz
wire   LCD_CLK = CLK_12MHZ;
assign o_LCD_CLK = LCD_CLK;

reg CLK_12MHZ;
always @(posedge i_clk) begin
    CLK_12MHZ = CLK_12MHZ + 1'b1;
end    


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
    .i_clk     (LCD_CLK),    // counter clock
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

assign o_LCD_HSYNC = hsync_delayed;
assign o_LCD_VSYNC = vsync_delayed;
assign o_LCD_DEN   = enable_delayed;


/*************************************
/*  Part III: Text
/*************************************/

// Demo module. Write into character buffer.
// Demo mode works better with a blank screen
wire [7:0]  charnum;
wire [5:0]  x_cell     = x[8:3];  // 60 cols
wire [4:0]  y_cell     = y[8:4];  // 17 rows
wire [10:0] video_addr = {y_cell, x_cell};

// Character buffer
charbuf_mono_64x32 charbuf_mono_64x32(
    // A port: write
    .ada       (i_vram_addr), //input [10:0] A address
    .din       (i_vram_data), //input [7:0]  Data in
    .clka      (i_clk),       //input clock for A port
    .cea       (i_vram_ce),   //input clock enable for A
    .reseta    (false),       //input reset for A

    // B port: read
    .adb       (video_addr), //input [10:0] B address
    .dout      (charnum),    //output [7:0] Data out
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
wire [14:0] rom_addr = {charnum, y_char_delayed, x_char_delayed};

// Character generator, monochrome, 8x16 font
rom_font_1bit_8x16 rom_font_1bit_8x16(
    .ad       (rom_addr), // [14:0] address
    .clk      (LCD_CLK),
    .dout     (pxon),     // output is ON/OFF
    .oce      (true),     // output enable
    .ce       (true),     // chip enable
    .reset    (false)
);


assign o_LCD_R = {5{pxon}};
assign o_LCD_G = {6{pxon}};
assign o_LCD_B = {5{pxon}};

endmodule

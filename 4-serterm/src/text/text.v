/*
This module creates the text engine and instanciate the video memory.
Also generates the cursor
*/
module text (
    input i_clk,                    // Clock (24 MHz)
    // VRAM port: for upper controller
    input [10:0]    i_vram_addr,    // VRAM address {5'y, 6'x}
    input  [7:0]    i_vram_din,     // VRAM data in
    output [7:0]    i_vram_dout,    // VRAM data out
    input           i_vram_ce,      // VRAM clock enable
    input           i_vram_wre,     // VRAM write/read
    // Cursor options
    input           i_cursor_e,     // Cursor enable
    input  [3:0]    i_cursor_h,     // Cursor height in lines (max: 16)
    // LCD signals
    output [4:0]    o_LCD_R,        // LCD red
    output [5:0]    o_LCD_G,        // LCD green
    output [4:0]    o_LCD_B,        // LCD blue
    output          o_LCD_HSYNC,    // LCD horizontal sync
    output          o_LCD_VSYNC,    // LCD vertical sync
    output          o_LCD_CLK,      // LCD clock
    output          o_LCD_DEN       // LCD data enable
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
vram_m64x32 vram(
    // A port: for upper controller
    .ada       (i_vram_addr),  //input [10:0] A address
    .dina      (i_vram_din),   //input  [7:0] A data in
    .douta     (i_vram_dout),  //output [7:0] A data out
    .wrea      (i_vram_wre),   //input A write/read
    .clka      (i_clk),        //input clock for A port 
    .cea       (i_vram_ce),    //input clock enable for A
    .reseta    (false),        //input reset for A

    // B port: for VGA engine
    .adb       (video_addr),   //input [10:0] B address
    .dinb      (8'b0),         //input  [7:0] B data in
    .doutb     (charnum),      //output [7:0] B data out
    .wreb      (false),        //input B write/read
    .clkb      (LCD_CLK),      //input clock for B port 
    .ceb       (true),         //input clock enable for B
    .resetb    (false),        //input reset for B

    .ocea      (true),         //input Output Clock Enable A (not used in bypass mode)
    .oceb      (true)          //input Output Clock Enable B (not used in bypass mode)
);



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

wire chr_on; // pixel is ON/OFF due to character generador
// Character generator, monochrome, 8x16 font
rom_font_1bit_8x16 rom_font_1bit_8x16(
    .ad       (rom_addr), // [14:0] address
    .clk      (LCD_CLK),
    .dout     (chr_on),   // output is ON/OFF
    .oce      (true),     // output enable
    .ce       (true),     // chip enable
    .reset    (false)
);

/*************************************
/*  Part VI: Cursor
/*************************************/

wire cur_on;
wire cur_on_delayed;

cursor cursor (
    .i_vsync        (o_LCD_VSYNC),          // frame clock
    .i_h            (i_cursor_h),           // cursor height in lines (0 = bottom, 15 = full)
    .i_wr_cell_x    (i_vram_addr[5:0]),     // x coordinate of the writing cell
    .i_wr_cell_y    (i_vram_addr[10:6]),    // y coordinate of the writing cell
    .i_cell_x       (x_cell),               // x coordinate of the cell being drawn
    .i_cell_y       (y_cell),               // x coordinate of the cell being drawn
    .i_char_y       (y[3:0]),               // y coordinate of the line being drawn
    .o_cursor       (cur_on)                // cursor pixel status
);


// Delay the cursor signal 2 tics
delaybit_2tic delay_cur(
    .clk  (LCD_CLK),
    .in   (cur_on),
    .out  (cur_on_delayed)
);

// Cursor signal xor with current caracter
wire pxon = chr_on ^ (i_cursor_e & cur_on_delayed); // pixel is ON/OFF

assign o_LCD_R = {5{pxon}};
assign o_LCD_G = {6{pxon}};
assign o_LCD_B = {5{pxon}};

endmodule

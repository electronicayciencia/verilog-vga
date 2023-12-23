// This module instantiate the VRAM, and creates the text and the cursor.
// Also exposes the VRAM port A for the controller part.
module video (
    input i_clk,                    // Clock (12 MHz)
    input i_reversev,               // Reverse video, for bel signal

    // VRAM port for the controller
    input [10:0]    i_vram_addr,    // VRAM address {5'y, 6'x}
    input  [7:0]    i_vram_din,     // VRAM data in
    output [7:0]    o_vram_dout,    // VRAM data out
    input           i_vram_clk,     // VRAM clock
    input           i_vram_ce,      // VRAM clock enable
    input           i_vram_wre,     // VRAM write/read

    // LCD signals
    output [4:0]    o_LCD_R,        // LCD red
    output [5:0]    o_LCD_G,        // LCD green
    output [4:0]    o_LCD_B,        // LCD blue
    output          o_LCD_HSYNC,    // LCD horizontal sync
    output          o_LCD_VSYNC,    // LCD vertical sync
    output          o_LCD_CLK,      // LCD clock
    output          o_LCD_DEN       // LCD data enable
);

parameter false = 1'b0;
parameter true = 1'b1;

/*************************************
/*  Character buffer
/*************************************/
wire [10:0] bvram_addr;
wire  [7:0] bvram_dout;

vram_m64x32 vram(
    // A port: for the controller
    .ada       (i_vram_addr),  //input [10:0] A address
    .dina      (i_vram_din),   //input  [7:0] A data in
    .douta     (o_vram_dout),  //output [7:0] A data out
    .wrea      (i_vram_wre),   //input A write/read
    .clka      (i_vram_clk),   //input clock for A port 
    .cea       (i_vram_ce),    //input clock enable for A
    .reseta    (false),         //input reset for A

    // B port: for the text engine
    .adb       (bvram_addr),    //input [10:0] B address
    .dinb      (8'b0),          //input  [7:0] B data in
    .doutb     (bvram_dout),    //output [7:0] B data out
    .wreb      (false),        //input B port is read-only
    .clkb      (i_clk),        //input clock for B port 
    .ceb       (true),         //input clock enable for B
    .resetb    (false),        //input reset for B

    .ocea      (true),         //input Output Clock Enable A (not used in bypass mode)
    .oceb      (true)          //input Output Clock Enable B (not used in bypass mode)
);


/*************************************
/*  Text engine
/*************************************/
wire chr_on;
/* Generate LCD output for the text and cursor
   Provides the interface for write into the VRAM */
text text(
    .i_clk          (i_clk),        // Clock (12 MHz)

    // VRAM handler
    .i_char_data    (bvram_dout),   // get the character data (monochrome)
    .o_video_addr   (bvram_addr),   // VRAM address

    // LCD signals
    .o_pxon         (chr_on),       // Monochrome pixel can be on/off
    .o_LCD_HSYNC    (o_LCD_HSYNC),  // LCD horizontal sync
    .o_LCD_VSYNC    (o_LCD_VSYNC),  // LCD vertical sync
    .o_LCD_CLK      (o_LCD_CLK),    // LCD clock
    .o_LCD_DEN      (o_LCD_DEN)     // LCD data enable
);


/*************************************
/*  Cursor
/*************************************/
/* 
To support cursor height we must access the internals of text render engine
in order to know with horizontal line is being drawn right now.
Instead of this, we will use a simpler version. A static full cell cursor.
Height should be 4'd1 to imitate classic cursor.

cursor cursor (
    .i_vsync        (o_LCD_VSYNC),          // frame clock
    .i_h            (i_cursor_h),           // cursor height in lines (0 = bottom, 15 = full) 4'd1 to imitate classic cursor.
    .i_wr_cell_x    (i_vram_addr[5:0]),     // x coordinate of the writing cell
    .i_wr_cell_y    (i_vram_addr[10:6]),    // y coordinate of the writing cell
    .i_cell_x       (x_cell),               // x coordinate of the cell being drawn
    .i_cell_y       (y_cell),               // x coordinate of the cell being drawn
    .i_char_y       (y[3:0]),               // y coordinate of the line being drawn
    .o_cursor       (cur_on)                // cursor pixel status
);
*/

wire cur_on = i_vram_addr == bvram_addr; // simplest cursor

// Delay the cursor signal 2 tics
wire cur_on_delayed;

delaybit_2tic delay_cur(
    .clk  (i_clk),
    .in   (cur_on),
    .out  (cur_on_delayed)
);

/*************************************
/*  Visual bel
/*************************************/
/* Latch the bel signal for the whole screen refresh to prevent artifacts. */
reg reversev = false;
always @(negedge o_LCD_VSYNC)
    reversev <= i_reversev;

// Cursor signal xor with current caracter, same with bel
wire pxon = chr_on ^ cur_on_delayed ^ reversev; // pixel is ON/OFF



/*************************************
/*  Text color
/*************************************/
parameter MASK_R = 5'b00000;
parameter MASK_G = 6'b011000;
parameter MASK_B = 5'b00000;

assign o_LCD_R = {5{pxon}} & MASK_R;
assign o_LCD_G = {6{pxon}} & MASK_G;
assign o_LCD_B = {5{pxon}} & MASK_B;



endmodule
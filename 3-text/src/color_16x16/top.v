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

// Color character buffer.
wire [9:0] buff_addr = {y[8:4], x[8:4]};
wire [15:0] buff_out;
wire [7:0] character = buff_out[7:0];
wire [7:0] attribute = buff_out[15:8];

charbuf_color_32x32 charbuf_color_32x32(
    //A port: write
    .ada       (10'b0),      //input [9:0] A address
    .din       (16'b0),      //input [15:0] Data in
    .clka      (LCD_CLK),    //input clock for A port
    .cea       (false),      //input clock enable for A
    .reseta    (false),      //input reset for A

    //B port: read
    .adb       (buff_addr),  //input [9:0] B address
    .dout      (buff_out),   //output [15:0] Data out
    .clkb      (LCD_CLK),    //input clock for B port
    .ceb       (true),       //input clock enable for B
    .resetb    (false),      //input reset for B

    //Global
    .oce       (true)        //input Output Clock Enable (not used in bypass mode)
);


// Delay inner cell coordinates to wait for character buffer.
wire [2:0] x_cell_timed = x[3:1];
wire [2:0] y_cell_timed = y[3:1];
wire [2:0] x_cell_delayed;
wire [2:0] y_cell_delayed;

delayvector3_1tic delay_xcell(
    .clk  (LCD_CLK),
    .in   (x_cell_timed),
    .out  (x_cell_delayed)
);

delayvector3_1tic delay_ycell(
    .clk  (LCD_CLK),
    .in   (y_cell_timed),
    .out  (y_cell_delayed)
);

// Character generator, 8x8 font
wire on;
wire [13:0] rom_addr = {character, y_cell_delayed, x_cell_delayed}; // 256 chars, 8 rows, 8 cols
rom_font_1bit rom_font_1bit(
    .ad       (rom_addr), //[13:0] address
    .clk      (LCD_CLK),
    .dout     (on),       // 1 bit
    .oce      (true),
    .ce       (true),
    .reset    (false)
);

// Color module
color color (
    .i_attr   (attribute), // Color attribute. irgb back (8b), irgb fore (8b)
    .i_active (on),        // pixel active (foreground color) or background color
    .o_red    (LCD_R),
    .o_green  (LCD_G),
    .o_blue   (LCD_B)
);

endmodule

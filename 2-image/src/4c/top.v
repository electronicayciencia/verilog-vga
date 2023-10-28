module top (
    input XTAL_IN,       // 24 MHz
    input BTN_A,         // color palette
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

delay delay_h(
    .clk  (LCD_CLK),
    .in   (hsync_timed),
    .out  (hsync_delayed)
);

delay delay_v(
    .clk  (LCD_CLK),
    .in   (vsync_timed),
    .out  (vsync_delayed)
);

delay delay_en(
    .clk  (LCD_CLK),
    .in   (enable_timed),
    .out  (enable_delayed)
);

assign LCD_HSYNC = hsync_delayed;
assign LCD_VSYNC = vsync_delayed;
assign LCD_DEN   = enable_delayed;



// Read from Memory

wire false = 1'b0;
wire true = 1'b1;

wire [1:0] rom_out;
wire [14:0] rom_addr;

// Double x and y pixels 
assign rom_addr = {y[7:1], x[8:1]};

// Black lines when y > 256
wire blackout = y[8];

rom_4c ROM(
    .dout      (rom_out),    //output [1:0] dout
    .clk       (LCD_CLK),    //input clk
    .oce       (true),       //input oce
    .ce        (true),       //input ce
    .reset     (false),      //input reset
    .ad        (rom_addr)    //input [14:0] address
);


wire [4:0] R;
wire [5:0] G;
wire [4:0] B;

palette palette (
    .i_color   (rom_out),    // color index
    .i_palette (~BTN_A),     // palette number
    .o_red     (R),
    .o_green   (G),
    .o_blue    (B)
);

assign LCD_R = R & {5{~blackout}};
assign LCD_G = G & {6{~blackout}};
assign LCD_B = B & {5{~blackout}};

endmodule
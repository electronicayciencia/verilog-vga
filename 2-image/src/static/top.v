/* Display static noise in the LCD using video RAM. */
module top (
    input XTAL_IN,       // 24 MHz
    input BTN_A,         // stop RAM writes (freeze screen content)
    output [4:0] LCD_R,
    output [5:0] LCD_G,
    output [4:0] LCD_B,
    output LCD_HSYNC,
    output LCD_VSYNC,
    output LCD_CLK,
    output LCD_DEN
);

wire master_clk;

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

wire mem_b_out;
wire [15:0] mem_b_addr;

// Double x pixels 
assign mem_b_addr = {y[7:0], x[8:1]};

wire [15:0] mem_a_addr;
wire mem_a_in;

// Video RAM
video_ram video_ram(
    //A port: write
    .ada       (mem_a_addr), //input [15:0] ada
    .din       (mem_a_in),   //input [0:0] din
    .clka      (LCD_CLK),    //input clka
    .cea       (BTN_A),      //input cea
    .reseta    (false),      //input reseta

    //B port: read
    .adb       (mem_b_addr), //input [15:0] adb
    .dout      (mem_b_out),  //output [0:0] dout
    .clkb      (LCD_CLK),    //input clkb
    .ceb       (true),       //input ceb
    .resetb    (false),      //input resetb

    // Chip global
    .oce       (true)        //input oce
);

// Write random bits to RAM's port A.
rand_mem rand_mem(
    .o_addr    (mem_a_addr),
    .o_dat     (mem_a_in),
    .i_clk     (LCD_CLK)
);


assign LCD_R = {5{mem_b_out}};
assign LCD_G = {6{mem_b_out}};
assign LCD_B = {5{mem_b_out}};


endmodule
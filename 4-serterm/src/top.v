module top (
    input XTAL_IN,       // 24 MHz
    output [4:0] LCD_R,
    output [5:0] LCD_G,
    output [4:0] LCD_B,
    output LCD_HSYNC,
    output LCD_VSYNC,
    output LCD_CLK,
    output LCD_DEN,
    input BTN_A,
    output LED_R,
    output LED_G,
    output LED_B
);

wire false = 1'b0;
wire true = 1'b1;

wire CLK_12MHZ;

// Use 24/2 = 12MHz for LCD and system clock.
clk_div clk_div (
    .i_clk(XTAL_IN),
    .i_factor(5'd0),     // 0: /2,  1: /4,  2: /8 ...
    .o_clk(CLK_12MHZ)
);


wire        vram_w   , scroll_vram_w   , clear_vram_w      ;
wire        vram_ce  , scroll_vram_ce  , clear_vram_ce     ;
wire [10:0] vram_addr, scroll_vram_addr, clear_vram_addr   ;
wire  [7:0] vram_dout, scroll_vram_dout, clear_vram_dout   ;
wire  [7:0] vram_din , scroll_vram_din , clear_vram_din    ;

reg [5:0] row = 0;
reg [6:0] col = 0;

wire scroll_start = false;
wire scroll_running;

// When a module is active, it takes the VRAM wires
assign vram_w    = scroll_running ? scroll_vram_w : 
                   clear_running ? clear_vram_w : 
                   false;

assign vram_ce   = scroll_running ? scroll_vram_ce : 
                   clear_running ? clear_vram_ce : 
                   false;

assign vram_addr = scroll_running ? scroll_vram_addr :
                   clear_running ? clear_vram_addr : 
                   {row,col};

assign vram_din  = scroll_running ? scroll_vram_din :
                   clear_running ? clear_vram_din : 
                   false;

assign scroll_vram_dout = scroll_running ? vram_dout : false;


push_button push_button (
    .i_btn   (~BTN_A),       // button active high
    .i_delay (2_000_000),    // [31:0] ticks to wait for repeat
    .i_clk   (CLK_12MHZ),
    .o_pulse (clear_start)   // output is high for 1 tick
);


scroll scroll_m(
    .i_clk          (CLK_12MHZ),
    .i_start        (scroll_start),     // assert high to start scrolling
    .o_running      (scroll_running),   // busy
    .o_vram_addr    (scroll_vram_addr),
    .o_vram_w       (scroll_vram_w),
    .o_vram_ce      (scroll_vram_ce),
    .i_vram_dout    (scroll_vram_dout),
    .o_vram_din     (scroll_vram_din)
);


clear clear_m(
    .i_clk          (CLK_12MHZ),
    .i_start        (clear_start),     // assert high to start cleaning
    .o_running      (clear_running),   // busy
    .o_vram_addr    (clear_vram_addr),
    .o_vram_w       (clear_vram_w),
    .o_vram_ce      (clear_vram_ce),
    .o_vram_din     (clear_vram_din)
);



/* Generate LCD output for the text and cursor
   Provides the interface for write into the VRAM */
text text(
    .i_clk          (CLK_12MHZ),  // Clock (12 MHz)

    // VRAM port: for upper controller
    .i_vram_addr    (vram_addr),  // VRAM address {5'y, 6'x}
    .i_vram_din     (vram_din),   // VRAM data in
    .i_vram_dout    (vram_dout),  // VRAM data out
    .i_vram_clk     (CLK_12MHZ),  // VRAM clock
    .i_vram_ce      (vram_ce),    // VRAM clock enable
    .i_vram_wre     (vram_w),     // VRAM write / read

    // Cursor options
    .i_cursor_e     (true),       // Cursor enable
    .i_cursor_h     (4'd1),       // cursor lines (0 = bottom, 15 = full)

    // LCD signals
    .o_LCD_R        (LCD_R),      // LCD red
    .o_LCD_G        (LCD_G),      // LCD green
    .o_LCD_B        (LCD_B),      // LCD blue
    .o_LCD_HSYNC    (LCD_HSYNC),  // LCD horizontal sync
    .o_LCD_VSYNC    (LCD_VSYNC),  // LCD vertical sync
    .o_LCD_CLK      (LCD_CLK),    // LCD clock
    .o_LCD_DEN      (LCD_DEN)     // LCD data enable
);

//assign LED_G = ~(wait_time == 0);
//assign LED_B = true;
//assign LED_R = ~running;

endmodule




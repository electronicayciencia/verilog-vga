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

// Use 24/2 = 12MHz for LCD and system clock.
reg CLK_12MHZ;
always @(posedge XTAL_IN) begin
    CLK_12MHZ = ~CLK_12MHZ;
end

/*
reg [32:0] ctr;
wire slowclock = ctr[23];
always @(negedge XTAL_IN)
    ctr = ctr + 1'b1;
*/


wire vram_w;
wire vram_ce;
wire [10:0] vram_addr;
wire  [7:0] vram_dout;
wire  [7:0] vram_din;


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

wire scroll_now;

push_button push_button (
    .i_btn   (~BTN_A),     // button active high
    .i_delay (2_000_000),  // [31:0] ticks to wait for repeat
    .i_clk   (CLK_12MHZ),
    .o_pulse (scroll_now)  // output is high for 1 tick
);


//assign LED_G = ~(wait_time == 0);
//assign LED_B = true;
//assign LED_R = ~running;

scroll scroll_m(
    .i_clk          (CLK_12MHZ),
    .i_start        (scroll_now),  // assert high to start scrolling
    .o_running      (running),     // busy
    .o_vram_addr    (vram_addr),
    .o_vram_w       (vram_w),
    .o_vram_ce      (vram_ce),
    .i_vram_dout    (vram_dout),
    .o_vram_din     (vram_din)
);

endmodule




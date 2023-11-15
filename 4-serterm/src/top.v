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


wire vram_w;
wire vram_ce;
wire [10:0] vram_addr;
wire  [7:0] vram_dout;
wire  [7:0] vram_din;


/* Generate LCD output for the text and cursor
   Provides the interface for write into the VRAM */
text text(
    .i_clk          (XTAL_IN),  // Clock (24 MHz)

    // VRAM port: for upper controller
    .i_vram_addr    (vram_addr),// VRAM address {5'y, 6'x}
    .i_vram_din     (vram_din), // VRAM data in
    .i_vram_dout    (vram_dout),// VRAM data out
    .i_vram_ce      (vram_ce),  // VRAM clock enable
    .i_vram_wre     (vram_w),   // VRAM write / read

    // Cursor options
    .i_cursor_e     (true),     // Cursor enable
    .i_cursor_h     (4'd1),     // cursor lines (0 = bottom, 15 = full)

    // LCD signals
    .o_LCD_R        (LCD_R),    // LCD red
    .o_LCD_G        (LCD_G),    // LCD green
    .o_LCD_B        (LCD_B),    // LCD blue
    .o_LCD_HSYNC    (LCD_HSYNC),// LCD horizontal sync
    .o_LCD_VSYNC    (LCD_VSYNC),// LCD vertical sync
    .o_LCD_CLK      (LCD_CLK),  // LCD clock
    .o_LCD_DEN      (LCD_DEN)   // LCD data enable
);



reg [32:0] ctr;
wire slowclock = ctr[0];
always @(negedge XTAL_IN)
    ctr = ctr + 1'b1;


reg scroll;
reg [31:0] wait_time = 0;
localparam [31:0] start_delay = 12_000_000;
always @(negedge XTAL_IN) begin
    if (~BTN_A) begin
        if (wait_time == 0) begin
            scroll <= 1;
            wait_time <= start_delay;
        end
        else begin
            scroll <= 0;
            wait_time <= wait_time == 0 ? 0 : wait_time - 1'b1;
        end
    end
    else begin
        wait_time <= wait_time == 0 ? 0 : wait_time - 1'b1;
        scroll <= 0;
    end
end



wire running;
assign LED_G = ~(wait_time == 0);
//assign LED_B = true;
//assign LED_R = ~running;

scroll scroll_m(
    .i_clk          (XTAL_IN),
    .i_start        (scroll),        // assert high to start scrolling
    .o_running      (running),                    // busy
    .o_vram_addr    (vram_addr),
    .o_vram_w       (vram_w),
    .o_vram_ce      (vram_ce),
    .i_vram_dout    (vram_dout),
    .o_vram_din     (vram_din)
);

endmodule




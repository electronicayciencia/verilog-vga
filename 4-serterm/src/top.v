module top (
    input XTAL_IN,       // 24 MHz
    output [4:0] LCD_R,
    output [5:0] LCD_G,
    output [4:0] LCD_B,
    output LCD_HSYNC,
    output LCD_VSYNC,
    output LCD_CLK,
    output LCD_DEN,
    input BTN_A
);

wire false = 1'b0;
wire true = 1'b1;

reg [4:0] row = 5'd0;
reg [5:0] col = 6'd0;


/* Generate LCD output for the text and cursor
   Provides the interface for write into the VRAM */
text text(
    .i_clk          (XTAL_IN),  // Clock (24 MHz)

    // VRAM port: for upper controller
    .i_vram_addr    ({row, col}),// VRAM address {5'y, 6'x}
    .i_vram_din     (8'b0),     // VRAM data in
    .i_vram_dout    (),         // VRAM data out
    .i_vram_ce      (false),    // VRAM clock enable
    .i_vram_wre     (false),    // VRAM write / read

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


/*
localparam lines = 17;
localparam cols  = 60;

always @(negedge BTN_A) begin
    if (col == cols - 1)
        row
        col <= 0;
    else
        col <= col + 1'b1;
end
*/

// Scroll
/*
localparam STATE_IDLE = 0,
           STATE_SCROLLING = 1

reg [4:0] old_row = 5'd0;
reg [5:0] old_col = 6'd0;

reg status = STATE_IDLE;
always @(negedge XTAL_IN) begin
    if (status == STATE_IDLE) begin
        status <= STATE_SCROLLING;
        old_row <= row;
        old_col <= col;
        row <= 0;
        col <= 0;
    end

    if (status == STATE_SCROLLING) begin
        row

    end

end
*/
endmodule
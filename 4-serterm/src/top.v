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

text text(
    .i_clk          (XTAL_IN),  // Clock (24 MHz)

    // VRAM write port
    .i_vram_addr    (11'b00000_000000),    // VRAM write address {5'y, 6'x}
    .i_vram_data    (8'b0),     // VRAM write data
    .i_vram_ce      (false),    // VRAM write enable
    
    // Cursor options
    .i_cursor_e     (true),     // Cursor enable
    .i_cursor_h     (4'd1),     // cursor height in lines (0 = bottom, 15 = full)

    // LCD signals
    .o_LCD_R        (LCD_R),    // LCD red
    .o_LCD_G        (LCD_G),    // LCD green
    .o_LCD_B        (LCD_B),    // LCD blue
    .o_LCD_HSYNC    (LCD_HSYNC),// LCD horizontal sync
    .o_LCD_VSYNC    (LCD_VSYNC),// LCD vertical sync
    .o_LCD_CLK      (LCD_CLK),  // LCD clock
    .o_LCD_DEN      (LCD_DEN)   // LCD data enable
);


endmodule
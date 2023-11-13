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
    .i_clk          (XTAL_IN),

    // VRAM write port
    .i_vram_addr    (11'b0),
    .i_vram_data    (8'b0),
    .i_vram_ce      (false),

    // LCD signals
    .o_LCD_R          (LCD_R),
    .o_LCD_G          (LCD_G),
    .o_LCD_B          (LCD_B),
    .o_LCD_HSYNC      (LCD_HSYNC),
    .o_LCD_VSYNC      (LCD_VSYNC),
    .o_LCD_CLK        (LCD_CLK),
    .o_LCD_DEN        (LCD_DEN)
);


endmodule
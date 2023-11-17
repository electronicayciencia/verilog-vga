module top (
    input XTAL_IN,       // 24 MHz
    output [4:0] LCD_R,
    output [5:0] LCD_G,
    output [4:0] LCD_B,
    output LCD_HSYNC,
    output LCD_VSYNC,
    output LCD_CLK,
    output LCD_DEN,
//    output LED_R,
//    output LED_G,
//    output LED_B,
    input BTN_A,
    input BTN_B
);

localparam false = 1'b0;
localparam true = 1'b1;

localparam char = 8'h41;

wire CLK_12MHZ;

// Use 24/2 = 12MHz for LCD and system clock.
clk_div clk_div (
    .i_clk(XTAL_IN),
    .i_factor(5'd0),     // 0: /2,  1: /4,  2: /8 ...
    .o_clk(CLK_12MHZ)
);




push_button m_BTN_A (
    .i_btn   (~BTN_A),         // button active high
    .i_delay (0_200_000),      // [31:0] ticks to wait for repeat
    .i_clk   (CLK_12MHZ),
    .o_pulse (putchar_start)   // output is high for 1 tick
);

push_button m_BTN_B (
    .i_btn   (~BTN_B),         // button active high
    .i_delay (2_000_000),      // [31:0] ticks to wait for repeat
    .i_clk   (CLK_12MHZ),
    .o_pulse (clearhome_start) // output is high for 1 tick
);


control control (
    .i_clk       (CLK_12MHZ),
    .i_clearhome (clearhome_start), // pulse to do clearhome
    .i_putchar   (putchar_start),   // pulse to do putchar
    .i_char      (char),             // char to put
    .o_LCD_R     (LCD_R),
    .o_LCD_G     (LCD_G),
    .o_LCD_B     (LCD_B),
    .o_LCD_HSYNC (LCD_HSYNC),
    .o_LCD_VSYNC (LCD_VSYNC),
    .o_LCD_CLK   (LCD_CLK),
    .o_LCD_DEN   (LCD_DEN)
);


endmodule




module top (
    input XTAL_IN, // 24 MHz

    output [4:0] LCD_R,
    output [5:0] LCD_G,
    output [4:0] LCD_B,
    output LCD_HSYNC,
    output LCD_VSYNC,
    output LCD_CLK,
    output LCD_DEN,

    input  BTN_A, // If BTN_A is pressed, the original HID USB scan code
                  // is sent for unmapped keys instead of null.

//    output LED_R,
//    output LED_G,
//    output LED_B,

//    input  BTN_B,

    input  RXD_PC,
    output TXD_PC,

    input  RXD_KEYB,
    output TXD_KEYB
);

localparam false = 1'b0;
localparam true = 1'b1;

// We do not transmit data to the keyb.
assign TXD_KEYB = 1'bZ;


// Use 24/2 = 12MHz for LCD and system clock.
wire CLK_12MHZ;
clk_div clk_div (
    .i_clk(XTAL_IN),
    .i_factor(5'd0),     // 0: /2,  1: /4,  2: /8 ...
    .o_clk(CLK_12MHZ)
);



/**************************/
/* UART for PC
/**************************/

wire [7:0] uart_rx_axis_tdata;
wire uart_rx_axis_tvalid;
wire uart_rx_axis_tready;

wire [7:0] uart_tx_axis_tdata;
wire uart_tx_axis_tvalid;
wire uart_tx_axis_tready;

uart
uart_pc (
    .clk(CLK_12MHZ),
    .rst(false),
    // AXI input
    .s_axis_tdata(uart_tx_axis_tdata),
    .s_axis_tvalid(uart_tx_axis_tvalid),
    .s_axis_tready(uart_tx_axis_tready),
    // AXI output
    .m_axis_tdata(uart_rx_axis_tdata),
    .m_axis_tvalid(uart_rx_axis_tvalid),
    .m_axis_tready(uart_rx_axis_tready),
    // uart
    .rxd(RXD_PC),
    .txd(TXD_PC),
    // status
    .tx_busy(),
    .rx_busy(),
    .rx_overrun_error(),
    .rx_frame_error(),
    // configuration
    // prescale = 12_000_000/(1200*8)
    //.prescale(16'd1250) // 1200
    //.prescale(16'd2000) // 750
    //.prescale(16'd156)  // 9600
    //.prescale(16'd39)   // 38400
    .prescale(16'd13)     // 115200
);



control control (
    .i_clk       (CLK_12MHZ),
    .i_valid     (uart_rx_axis_tvalid),
    .i_char      (uart_rx_axis_tdata),   // char to put
    .o_ready     (uart_rx_axis_tready),
    .o_LCD_R     (LCD_R),
    .o_LCD_G     (LCD_G),
    .o_LCD_B     (LCD_B),
    .o_LCD_HSYNC (LCD_HSYNC),
    .o_LCD_VSYNC (LCD_VSYNC),
    .o_LCD_CLK   (LCD_CLK),
    .o_LCD_DEN   (LCD_DEN)
);


/*****************/
/* CH9350 keyboard
/*****************/
CH9350_keyboard keyboard (
    .i_clk        (CLK_12MHZ),
    .i_nullify    (BTN_A),
    .i_rxd        (RXD_KEYB),
    .i_data_ready (uart_tx_axis_tready),
    .o_data_valid (uart_tx_axis_tvalid),
    .o_data       (uart_tx_axis_tdata)  // mapped key goes directly to the PC
);


endmodule




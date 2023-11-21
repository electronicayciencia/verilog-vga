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

//    input  BTN_A,
//    input  BTN_B,

    input  RXD_PC,
    output TXD_PC,

    input  RXD_KEYB,
    output TXD_KEYB
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

/*
push_button m_BTN_A (
    .i_btn   (~BTN_A),         // button active high
    .i_delay (0_200_000),      // [31:0] ticks to wait for repeat
    .i_clk   (CLK_12MHZ),
    .o_pulse (rst)   // output is high for 1 tick
);


push_button m_BTN_B (
    .i_btn   (~BTN_B),         // button active high
    .i_delay (2_000_000),      // [31:0] ticks to wait for repeat
    .i_clk   (CLK_12MHZ),
    .o_pulse (clearhome_start) // output is high for 1 tick
);
*/

reg putchar_start = 0;


/**************************/
/* UART for PC
/**************************/

wire [7:0] uart_rx_axis_tdata;
wire uart_rx_axis_tvalid;
reg uart_rx_axis_tready = true;

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
    .prescale(16'd1250)
);



control control (
    .i_clk       (CLK_12MHZ),
    .i_clearhome (clearhome_start), // pulse to do clearhome
    .i_putchar   (putchar_start),   // pulse to do putchar
    .i_char      (uart_rx_axis_tdata),             // char to put
    .o_LCD_R     (LCD_R),
    .o_LCD_G     (LCD_G),
    .o_LCD_B     (LCD_B),
    .o_LCD_HSYNC (LCD_HSYNC),
    .o_LCD_VSYNC (LCD_VSYNC),
    .o_LCD_CLK   (LCD_CLK),
    .o_LCD_DEN   (LCD_DEN)
);


always @(posedge CLK_12MHZ) begin
    // putchar has no "running" signal
    // assume it has enough time between one byte and the next
    // then, ready to receive another byte
    if (putchar_start) begin
        putchar_start <= false;
        uart_rx_axis_tready <= false;
    end

    // got one, clear ready signal
    // and put it into the screen
    else if (uart_rx_axis_tvalid) begin
        uart_rx_axis_tready <= true;
        putchar_start <= true;
    end
end


/*****************/
/* Test keyboard
/*****************/
keyb_tests keyb_tests (
    .i_clk        (CLK_12MHZ),
    .i_rxd        (RXD_KEYB),
    .i_data_ready (uart_tx_axis_tready),
    .o_data_valid (uart_tx_axis_tvalid),
    .o_data       (uart_tx_axis_tdata)  // mapped key
);


endmodule




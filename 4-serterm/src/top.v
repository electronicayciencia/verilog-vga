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
    output LED_G,
//    output LED_B,
    input  BTN_A,
    input  BTN_B,
    input  RXD,
    output TXD
);

localparam false = 1'b0;
localparam true = 1'b1;

localparam char = 8'h41;

wire rst = false;

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

/**************************/
/* UART
/**************************/

reg [7:0] uart_tx_axis_tdata;
reg uart_tx_axis_tvalid;
wire uart_tx_axis_tready;

wire [7:0] uart_rx_axis_tdata;
wire uart_rx_axis_tvalid;
reg uart_rx_axis_tready;

uart
uart_inst (
    .clk(CLK_12MHZ),
    .rst(clearhome_start),
    // AXI input
    .s_axis_tdata(uart_tx_axis_tdata),
    .s_axis_tvalid(uart_tx_axis_tvalid),
    .s_axis_tready(uart_tx_axis_tready),
    // AXI output
    .m_axis_tdata(uart_rx_axis_tdata),
    .m_axis_tvalid(uart_rx_axis_tvalid),
    .m_axis_tready(uart_rx_axis_tready),
    // uart
    .rxd(RXD),
    .txd(TXD),
    // status
    .tx_busy(),
    .rx_busy(),
    .rx_overrun_error(),
    .rx_frame_error(),
    // configuration
    // prescale = 12_000_000/(1200*8)
    .prescale(16'd1250)
);

//assign led = sw;
assign LED_G = RXD;


always @(posedge CLK_12MHZ or posedge rst) begin
    if (rst) begin
        uart_tx_axis_tdata <= 0;
        uart_tx_axis_tvalid <= 0;
        uart_rx_axis_tready <= 0;
    end else begin
        if (uart_tx_axis_tvalid) begin
            // attempting to transmit a byte
            // so can't receive one at the moment
            uart_rx_axis_tready <= 0;
            // if it has been received, then clear the valid flag
            if (uart_tx_axis_tready) begin
                uart_tx_axis_tvalid <= 0;
            end
        end else begin
            // ready to receive byte
            uart_rx_axis_tready <= 1;
            if (uart_rx_axis_tvalid) begin
                // got one, so make sure it gets the correct ready signal
                // (either clear it if it was set or set it if we just got a
                // byte out of waiting for the transmitter to send one)
                uart_rx_axis_tready <= ~uart_rx_axis_tready;
                // send byte back out
                uart_tx_axis_tdata <= uart_rx_axis_tdata;
                uart_tx_axis_tvalid <= 1;
            end
        end
    end
end




endmodule




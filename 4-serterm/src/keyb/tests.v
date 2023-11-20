// Learn how to talk with CH9350 chip
module keyb_tests (
    input i_clk,       // 12 MHz
    input rxd,
    output txd
);


wire rst = 1'b0;


/**************************/
/* UART for Keyboard
/**************************/

wire [7:0] uart_tx_axis_tdata;
wire uart_tx_axis_tvalid;
wire uart_tx_axis_tready;

wire [7:0] uart_rx_axis_tdata;
wire uart_rx_axis_tvalid;
wire uart_rx_axis_tready;

uart
uart_inst (
    .clk(i_clk),
    .rst(rst),
    // AXI input
    .s_axis_tdata(uart_tx_axis_tdata),
    .s_axis_tvalid(uart_tx_axis_tvalid),
    .s_axis_tready(uart_tx_axis_tready),
    // AXI output
    .m_axis_tdata(uart_rx_axis_tdata),
    .m_axis_tvalid(uart_rx_axis_tvalid),
    .m_axis_tready(uart_rx_axis_tready),
    // uart
    .rxd(rxd),
    .txd(txd),
    // status
    .tx_busy(),
    .rx_busy(),
    .rx_overrun_error(),
    .rx_frame_error(),
    // prescale = 12_000_000/(38400*8)
    .prescale(16'd39)
);


// Translate USB bytes to UART keys
usbkeys usbkeys (
    .i_clk        (i_clk),
    // get a byte stream
    .i_byte       (uart_rx_axis_tdata),
    .i_byte_valid (uart_rx_axis_tvalid),
    .o_byte_ready (uart_rx_axis_tready),
    // output keys
    .i_key_ready  (uart_tx_axis_tready),
    .o_key_valid  (uart_tx_axis_tvalid),
    .o_key        (uart_tx_axis_tdata)
);


endmodule
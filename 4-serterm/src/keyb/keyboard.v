/* 
This module comunicates with CH9350 in order to receive keystrokes
When a keystroke is received, it is mapped into a character. 
Then, o_data_valid is asserted until i_data_ready is high.
- One key is mapped to one character, no multi-key or escape sequences.
- No auto-repeating keys.
- No caps-lock support.
- If a key is not recognized, the original HID USB code is transmitted.
*/
module CH9350_keyboard (
    input  i_clk,        // 12 MHz
    input  i_rxd,        // we only receive from keyboard
    input  i_data_ready,
    output o_data_valid,
    output [7:0] o_data  // mapped key
);

wire rst = 1'b0;

wire [7:0] uart_rx_axis_tdata;
wire uart_rx_axis_tvalid;
wire uart_rx_axis_tready;

// UART to receive CH9350 data
uart_rx #(
    .DATA_WIDTH(8)
)
uart_rx_inst (
    .clk(i_clk),
    .rst(rst),
    // axi output
    .m_axis_tdata(uart_rx_axis_tdata),
    .m_axis_tvalid(uart_rx_axis_tvalid),
    .m_axis_tready(uart_rx_axis_tready),
    // input
    .rxd(i_rxd),
    // status
    .busy(),
    .overrun_error(),
    .frame_error(),
    // this prescales depends on i_clk frequency and CH9350 baud rate selection
    // prescale = 12_000_000/(38400*8)
    .prescale(16'd39)
);


// Translate USB bytes to ascii codes
usbkeys usbkeys (
    .i_clk        (i_clk),
    // get a byte stream
    .i_byte       (uart_rx_axis_tdata),
    .i_byte_valid (uart_rx_axis_tvalid),
    .o_byte_ready (uart_rx_axis_tready),
    // output keys
    .i_key_ready  (i_data_ready),
    .o_key_valid  (o_data_valid),
    .o_key        (o_data)
);


endmodule
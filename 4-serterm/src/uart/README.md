# UART

This is the UART module. 

Imported from https://github.com/alexforencich/verilog-uart

## Example

```verilog
/**************************/
/* UART
/**************************/
wire rst = 1'b0;

reg [7:0] uart_tx_axis_tdata;
reg uart_tx_axis_tvalid;
wire uart_tx_axis_tready;

wire [7:0] uart_rx_axis_tdata;
wire uart_rx_axis_tvalid;
reg uart_rx_axis_tready;

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

always @(posedge i_clk or posedge rst) begin
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
```



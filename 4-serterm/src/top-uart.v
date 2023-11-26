// Test file to test some things
module top (

    /*
     * Clock: 125MHz
     * Synchronous reset
     */
    input  wire       clk_125mhz,
    input  wire       rst_125mhz,

    /*
     * GPIO
     */
    input  wire       btnu,
    input  wire       btnl,
    input  wire       btnd,
    input  wire       btnr,
    input  wire       btnc,
    input  wire [7:0] sw,
    output wire       ledu,
    output wire       ledl,
    output wire       ledd,
    output wire       ledr,
    output wire       ledc,
    output wire [7:0] led,

    /*
     * Ethernet: 1000BASE-T GMII
     */
    input  wire       phy_rx_clk,
    input  wire [7:0] phy_rxd,
    input  wire       phy_rx_dv,
    input  wire       phy_rx_er,
    output wire       phy_gtx_clk,
    output wire [7:0] phy_txd,
    output wire       phy_tx_en,
    output wire       phy_tx_er,
    output wire       phy_reset_n,

    /*
     * Silicon Labs CP2103 USB UART
     */
    output wire       uart_rxd,
    input  wire       uart_txd,
    input  wire       uart_rts,
    output wire       uart_cts
);

reg [7:0] uart_tx_axis_tdata;
reg uart_tx_axis_tvalid;
wire uart_tx_axis_tready;

wire [7:0] uart_rx_axis_tdata;
wire uart_rx_axis_tvalid;
reg uart_rx_axis_tready;

uart
uart_inst (
    .clk(clk_125mhz),
    .rst(rst_125mhz),
    // AXI input
    .s_axis_tdata(uart_tx_axis_tdata),
    .s_axis_tvalid(uart_tx_axis_tvalid),
    .s_axis_tready(uart_tx_axis_tready),
    // AXI output
    .m_axis_tdata(uart_rx_axis_tdata),
    .m_axis_tvalid(uart_rx_axis_tvalid),
    .m_axis_tready(uart_rx_axis_tready),
    // uart
    .rxd(uart_txd),
    .txd(uart_rxd),
    // status
    .tx_busy(),
    .rx_busy(),
    .rx_overrun_error(),
    .rx_frame_error(),
    // configuration
    .prescale(125000000/(9600*8))
);

//assign led = sw;
assign led = uart_tx_axis_tdata;
assign phy_reset_n = ~rst_125mhz;

assign phy_gtx_clk = 1'b0;
assign phy_txd = 8'd0;
assign phy_tx_en = 1'b0;
assign phy_tx_er = 1'b0;

always @(posedge clk_125mhz or posedge rst_125mhz) begin
    if (rst_125mhz) begin
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
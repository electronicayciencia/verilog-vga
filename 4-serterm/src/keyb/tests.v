// Learn how to talk with CH9350 chip
module keyb_tests (
    input i_clk,       // 12 MHz
    input rxd,
    output txd,
    output o_o
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


assign scancode_ready = uart_tx_axis_tready;
assign uart_tx_axis_tvalid = scancode_valid;
assign uart_tx_axis_tdata = code;

wire newchar_valid = uart_rx_axis_tvalid;
assign uart_rx_axis_tready = newchar_ready;


// Detect key
// (57 AB 01) (00) (00) (2C)
// Magic, mask, reserved, key scan code
localparam LEN = 3;
localparam [LEN*8-1:0] magic = "key";

localparam 
    LOOK  = 2'd0, // looking for the magic sequence
    MASK  = 2'd1, // sequence found, the nest byte is the mask
    RES   = 2'd2, // mask captured, nest byte is reserved and must be 0
    CODE  = 2'd3; // next is the key scan code

reg [1:0] status = LOOK;
reg [3:0] idx  = 0;
reg [7:0] mask = 0;
reg [7:0] code = 0;

reg newchar_ready = 1;
reg scancode_valid = 0; // is asserted until scancode_ready

wire [7:0] first = magic[8*(LEN-1) +: 8]; 
wire [7:0] next  = magic[8*(LEN-idx-1) +: 8];

always @(posedge i_clk) begin
    // next module ack'ed our newkey signal
    if (scancode_ready) begin
        scancode_valid <= 0;
        newchar_ready  <= 1;  // ready for a new char
    end

    // we received a new byte
    if (newchar_valid) begin
        case(status)

        LOOK: 
            begin
                // following the sequence
                if (uart_rx_axis_tdata == next)
                    if (idx == LEN - 1) begin
                        status <= MASK;
                        idx <= 0;
                    end
                    else
                        idx <= idx + 1'b1;
                // sequence start again inside a sequence
                else if (uart_rx_axis_tdata == first)
                    idx <= 1'b1;
                // out of sequence
                else
                    idx <= 0;
            end

        MASK:
            begin
                mask <= uart_rx_axis_tdata;
                status <= RES;
            end

        RES:
            status <= CODE;

        CODE:
            begin
                // halt data flow until our scan code is received
                newchar_ready <= 0;
                status <= LOOK;
                scancode_valid <= 1;
                code <= uart_rx_axis_tdata;
            end
        endcase
    end
end

assign o_o = status == CODE;

endmodule
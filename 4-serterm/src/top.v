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
    input  BTN_B, // If BTN_B is pressed, the original ASCII gliph is printed for
                  // control characters.

    output LED_R, // Break signal being transmitted
    output LED_G, // BTN_A active
    output LED_B, // BTN_B active

    input  RXD_PC,
    output TXD_PC,

    input  RXD_KEYB,
    output TXD_KEYB
);

`include "config.v"

localparam false    = 1'b0;
localparam true     = 1'b1;

// We do not transmit data to the keyb.
assign TXD_KEYB = 1'bZ;

/**************************/
/* System Clock
/**************************/
// Use 24/2 = 12MHz for LCD and system clock.
wire CLK_12MHZ;
clk_div clk_div (
    .i_clk(XTAL_IN),
    .i_factor(5'd0),     // 0: /2,  1: /4,  2: /8 ...
    .o_clk(CLK_12MHZ)
);


/**************************/
/* Buttons to configure
/**************************/
wire nullify;
wire ectlchrs;

assign LED_G = nullify,
       LED_B = ectlchrs,
       LED_R = ~break_signal;

toggle_button t_btn_a(
    .i_clk(CLK_12MHZ),
    .i_btn(BTN_A),
    .o_sw(nullify)
);

toggle_button t_btn_b (
    .i_clk(CLK_12MHZ),
    .i_btn(BTN_B),
    .o_sw(ectlchrs)
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

wire tx_pc_data;
wire break_signal;
assign TXD_PC = tx_pc_data & ~(break_signal);

localparam prescale = SYSCLK/(baudrate*8);

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
    .txd(tx_pc_data),
    // status
    .tx_busy(),
    .rx_busy(),
    .rx_overrun_error(),
    .rx_frame_error(),
    // configuration
    .prescale(prescale[15:0])

);

/**************************/
/* Video engine
/* Render the VRAM contents into video signals
/**************************/
wire [10:0] vram_addr; // VRAM address {5'y, 6'x}
wire  [8:0] vram_din;  // VRAM data in
wire  [8:0] vram_dout; // VRAM data out
wire        vram_clk;  // VRAM clock
wire        vram_ce;   // VRAM clock enable
wire        vram_wre;  // VRAM write/read
wire        bel;       // Bell ringing

video video (
    .i_clk       (CLK_12MHZ),    // Clock (12 MHz)
    .i_reversev  (bel),          // Reverse video

    // VRAM port for the controller
    .i_vram_addr (vram_addr),    // VRAM address {5'y, 6'x}
    .i_vram_din  (vram_din),     // VRAM data in
    .o_vram_dout (vram_dout),    // VRAM data out
    .i_vram_clk  (vram_clk),     // VRAM clock
    .i_vram_ce   (vram_ce),      // VRAM clock enable
    .i_vram_wre  (vram_wre),     // VRAM write/read

    // LCD signals
    .o_LCD_R     (LCD_R),        // LCD red
    .o_LCD_G     (LCD_G),        // LCD green
    .o_LCD_B     (LCD_B),        // LCD blue
    .o_LCD_HSYNC (LCD_HSYNC),    // LCD horizontal sync
    .o_LCD_VSYNC (LCD_VSYNC),    // LCD vertical sync
    .o_LCD_CLK   (LCD_CLK),      // LCD clock
    .o_LCD_DEN   (LCD_DEN)       // LCD data enable
);

/**************************/
/* RX characters
/* get characters and write the VRAM
/**************************/
control control (
    .i_clk       (CLK_12MHZ),
    .i_ectlchrs  (ectlchrs),  // enable control characters

    // Interface
    .i_valid     (uart_rx_axis_tvalid),
    .i_char      (uart_rx_axis_tdata),   // char to put
    .o_ready     (uart_rx_axis_tready),

    // VRAM handler
    .o_vram_addr (vram_addr), // VRAM address {5'y, 6'x}
    .o_vram_din  (vram_din),  // VRAM data in
    .i_vram_dout (vram_dout), // VRAM data out
    .o_vram_clk  (vram_clk),  // VRAM clock
    .o_vram_ce   (vram_ce),   // VRAM clock enable
    .o_vram_wre  (vram_wre),  // VRAM write/read

    // signal to other modules
    .o_bel       (bel)        // Bell active
);


/**************************/
/* TX characters
/* Get key pushes and send characters to the PC
/**************************/
CH9350_keyboard keyboard (
    .i_clk        (CLK_12MHZ),
    .i_nullify    (nullify),
    .i_rxd        (RXD_KEYB),
    .i_data_ready (uart_tx_axis_tready),
    .o_data_valid (uart_tx_axis_tvalid),
    .o_data       (uart_tx_axis_tdata),  // mapped key goes directly to the PC
    .o_break      (break_start)
);

/**************************/
/* TX break signal (hold TX line down for longer than 1+8 symbols)
/**************************/
break break_m (
    .i_clk      (CLK_12MHZ),
    .i_start    (break_start),
    .o_signal   (break_signal)
);

endmodule




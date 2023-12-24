// Create a toggle switch from a push button

module toggle_button (
    input      i_clk,
    input      i_btn,   // Active high
    output reg o_sw = 1
);

reg pressed = 0;

always @(posedge i_clk)
    pressed <= i_btn;

always @(posedge pressed)
    o_sw <= ~o_sw;

endmodule
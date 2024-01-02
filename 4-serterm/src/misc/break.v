// Generate the break signal (hold TX line down for longer than 1+8 symbols)
module break (
    input  i_clk,
    input  i_start,  // active high
    output o_signal  // active high
);

`include "../config.v"

localparam counter_max = 12 * SYSCLK / baudrate;
reg [23:0] ctr = 0;

always @(posedge i_clk) begin
    if (i_start)
        ctr <= counter_max[23:0];
    else
        ctr <= |ctr ? ctr - 1'b1 : ctr;
end

assign o_signal = |ctr;

endmodule
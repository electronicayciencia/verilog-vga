// Keep the bel ringing for some amount of time
module bel (
    input  i_clk,
    input  i_start,  // active high
    output o_bel     // active high
);

localparam maxtime = 600000; // 12e6 * 0.05

reg [24:0] ctr;
assign o_bel = |ctr;

always @(posedge i_clk) begin
    if (i_start)
        ctr <= maxtime;
    else 
        ctr <= ctr == 1'b0 ? ctr : ctr - 1'b1;
end


endmodule

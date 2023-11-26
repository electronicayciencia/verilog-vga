// Divide the frequency of a clock signal up to 2^32
module clk_div (
    input       i_clk,
    input [4:0] i_factor, // 0: /2,  1: /4,  2: /8 ...  up to 32
    output      o_clk
);

reg [31:0] ctr;

assign o_clk = ctr[i_factor];

always @(posedge i_clk) begin
    ctr = ctr + 1'b1;
end



endmodule
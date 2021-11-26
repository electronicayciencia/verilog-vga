// Simplest pattern. Same color for all pixels
module pat_fixed (
    input [8:0] i_x,
    input [8:0] i_y,
    output [4:0] o_R,
    output [5:0] o_G,
    output [4:0] o_B
);

assign o_R = 5'b11000;
assign o_G = 6'b010000;
assign o_B = 5'b00000;

endmodule
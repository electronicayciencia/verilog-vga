// 1 pixel white edge
module pat_edge (
    input [8:0] i_x,
    input [8:0] i_y,
    output [4:0] o_R,
    output [5:0] o_G,
    output [4:0] o_B
);

wire on = (i_x == 0) | (i_x == 479) | (i_y == 0) | (i_y == 271);

assign o_R = {on, 4'b0};
assign o_G = {on, 5'b0};
assign o_B = {on, 4'b0};

endmodule
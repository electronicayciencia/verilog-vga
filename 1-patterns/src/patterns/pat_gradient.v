// gradient pattern
module pat_gradient (
    input [8:0] i_x,
    input [8:0] i_y,
    output [4:0] o_R,
    output [5:0] o_G,
    output [4:0] o_B
);

assign o_R = i_x[8:4] & {5{i_y[7]}};
assign o_G = i_x[8:3] & {6{i_y[6]}};
assign o_B = i_x[8:4] & {5{i_y[5]}};

endmodule
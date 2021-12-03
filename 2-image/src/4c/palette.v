module palette_4c (
    input  [1:0] i_color,      // color index
    input  i_on,               // pixel is on
    output [4:0] o_red,
    output [5:0] o_green,
    output [4:0] o_blue
);

wire [4:0] red;
wire [5:0] green;
wire [4:0] blue;

assign red   = {5{i_color == 3 | i_color == 1}};
assign green = {6{i_color == 3 | i_color == 2}};
assign blue  = {5{i_color == 3 | i_color == 1 | i_color == 2}};

assign o_red   = i_on ? red   : 0;
assign o_green = i_on ? green : 0;
assign o_blue  = i_on ? blue  : 0;

endmodule

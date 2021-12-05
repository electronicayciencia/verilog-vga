/*
CGA classic palettes:

Palette #0:
              RED  GREEN  BLUE
00: black
01: red        X
10: green            X
11: yellow     X     X

Palette #1:
              RED  GREEN  BLUE
00: black
01: magenta    X           X
10: cian             X     X
11: white      X     X     X
*/

module palette (
    input  [1:0] i_color,  // color index
    input  i_palette,      // palette number
    output [4:0] o_red,
    output [5:0] o_green,
    output [4:0] o_blue
);

localparam i = 1'b0; // intensify

wire r;
wire g;
wire b;

assign r = i_color[0];
assign g = i_color[1];
assign b = |i_color;

assign o_red   = {r,i,r,i,r};
assign o_green = {g,i,g,i,g,i};
assign o_blue  = {b,i,b,i,b} & {5{i_palette}};  // blue only on palette #1

endmodule

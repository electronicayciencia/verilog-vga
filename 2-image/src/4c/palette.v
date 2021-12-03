/*
CGA classic palettes:


Palette #1:
              RED  GREEN  BLUE
00: black
01: magenta    X           X
10: cian             X     X
11: white      X     X     X

Palette #2:
              RED  GREEN  BLUE
00: black
01: red        X
10: cian             X
11: white      X     X

Intensity:

color:      . . . .
Color (8b): 00000000
intensisty:  ^ ^ ^ ^
*/

module palette (
    input  [1:0] i_color,  // color index
    input  i_palette,      // palette number
    output [4:0] o_red,
    output [5:0] o_green,
    output [4:0] o_blue
);

wire r;
wire g;
wire b;
wire i = 0; // no intensify line

assign r = i_color == 3 | i_color == 1;
assign g = i_color == 3 | i_color == 2;
assign b = i_color != 0 & i_palette == 0; // blue never on palette #2

assign o_red   = {r,i,r,i,r};
assign o_green = {g,i,g,i,g,i};
assign o_blue  = {b,i,b,i,b};

endmodule

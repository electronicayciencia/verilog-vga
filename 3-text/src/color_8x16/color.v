// Receive CGA color to drive LCD output R(5)G(6)B(5)
// "pixel on" signal select between foreground or background color.
// 00h => 00000000b
// 55h => 01010101b  (intensifier bit)
// AAh => 10101010b  (color bit)
// FFh => 11111111b
module color (
    input  [7:0] i_attr,   // Color attribute. irgb back (8b), irgb fore (8b)
    input        i_fg,     // pixel active (foreground color) or background color
    output [4:0] o_red,
    output [5:0] o_green,
    output [4:0] o_blue
);

assign {i,r,g,b} = i_fg ? i_attr[3:0] : i_attr[7:4];

assign o_red   = { r, i, r, i, r };
assign o_green = { g, i, g, i, g, i };
assign o_blue  = { b, i, b, i, b };

endmodule

// Receive CGA color to drive LCD output R(5)G(6)B(5)
// "pixel on" signal select between foreground or background color.
module color (
    input  [7:0] i_attr,    // Color attribute. irgb back (8b), irgb fore (8b)
    input        i_active,  // pixel active (foreground color) or background color
    output [4:0] o_red,
    output [5:0] o_green,
    output [4:0] o_blue
);

wire back_i = i_attr[7];
wire back_r = i_attr[6];
wire back_g = i_attr[5];
wire back_b = i_attr[4];

wire fore_i = i_attr[3];
wire fore_r = i_attr[2];
wire fore_g = i_attr[1];
wire fore_b = i_attr[0];

wire i     = i_active ? fore_i : back_i;
wire red   = i_active ? fore_r : back_r;
wire green = i_active ? fore_g : back_g;
wire blue  = i_active ? fore_b : back_b;

// 00h => 00000000b
// 55h => 01010101b  (intensifier bit)
// AAh => 10101010b  (color bit)
// FFh => 11111111b

assign o_red   = { red,   i, red,   i, red };
assign o_green = { green, i, green, i, green, i };
assign o_blue  = { blue,  i, blue,  i, blue };

endmodule

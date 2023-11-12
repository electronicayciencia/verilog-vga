// Receive CGA color to drive LCD output R(5)G(6)B(5)
// "pixel on" signal select between foreground or background color.
// 00h => 00000000b
// 55h => 01010101b  (intensifier bit)
// AAh => 10101010b  (color bit)
// FFh => 11111111b
module color_blink (
    input  [7:0] i_attr,   // Color attribute. irgb back (8b), irgb fore (8b)
    input        i_fg,     // pixel active (foreground color) or background color
    input        i_blink,  // blinking line
    input        i_ble,    // blink enable
    output [4:0] o_red,
    output [5:0] o_green,
    output [4:0] o_blue
);

wire i, r, g, b;

assign {i,r,g,b} = i_ble ? 
                   (i_fg & (i_blink | ~i_attr[7]) ? i_attr[3:0] : {1'b0, i_attr[6:4]}) :
                   (i_fg ? i_attr[3:0] : i_attr[7:4]);

assign o_red   = { r, i, r, i, r };
assign o_blue  = { b, i, b, i, b };

// Brown exception: turn green from AA to 55 if the color is 6
assign o_green = {i,r,g,b} != 4'b0110 ? { g, i, g, i, g, i } : 5'b010101;


endmodule

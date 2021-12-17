// Character generator, monochrome, 8x8 font
// Version for 1 bit ROM
module text_1bit (
    input [2:0] i_x,     // horizontal coordinate
    input [2:0] i_y,     // vertical coordinate
    input [7:0] i_chr,   // character number
    input i_clk,         // clock
    output o_out         // pixel is on
);

wire false = 1'b0;
wire true = 1'b1;

// work with 8x8 blocks (cells)
wire [13:0] rom_addr = {i_chr, i_y, i_x}; // 256 chars, 8 rows, 8 cols

rom_font_1bit rom_font_1bit(
    .ad       (rom_addr), //[13:0] address
    .clk      (i_clk),
    .dout     (o_out),    // 1 bit
    .oce      (true),
    .ce       (true),
    .reset    (false)
);

endmodule

// Character generator 8x8 font
// Version for 8 bit ROM
module text_1bit (
    input [2:0] i_x,     // horizontal coordinate
    input [2:0] i_y,     // vertical coordinate
    input [7:0] i_chr,   // character number
    input i_clk,         // clock
    output o_out         // pixel is on
);

wire false = 1'b0;
wire true = 1'b1;

wire [10:0] rom_addr = {i_chr, i_y}; // 256 chars, 8 rows
wire [7:0] chr_row; // whole character row (8 pixels)

rom_font rom_font(
    .ad       (rom_addr), //[10:0] address
    .clk      (i_clk),
    .dout     (chr_row),  // 8 bit
    .oce      (true),
    .ce       (true),
    .reset    (false)
);

// Horizontal coordinate selects which pixel to output
// Cannot use a shift register because it won't work with doubled text (16x16 cells)
wire [2:0] reverse = -i_x;
assign o_out = chr_row[reverse +: 1];

endmodule
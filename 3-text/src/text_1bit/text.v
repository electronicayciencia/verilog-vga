// Character generator, monochrome, 8x8 font, 1 bit
module text (
    input [8:0] i_x,     // horizontal coordinate
    input [8:0] i_y,     // vertical coordinate
    input i_clk,         // clock
    output o_on          // pixel is on
);

wire false = 1'b0;
wire true = 1'b1;

// work with 8x8 blocks (cells)
wire [13:0] rom_addr = {8'h61, i_y[2:0], i_x[2:0]}; // 256 chars, 8 rows, 8 cols
wire font_rom_out;

font_rom font_rom(
    .ad       (rom_addr), //[13:0] address
    .clk      (i_clk),
    .dout     (o_on),     // 1 bit
    .oce      (true),
    .ce       (true),
    .reset    (false)
);


endmodule

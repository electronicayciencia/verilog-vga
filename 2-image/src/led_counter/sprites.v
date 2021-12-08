// Select the proper 32x32 16bit sprite between 4 available
module sprites (
    input [8:0] i_x,     // horizontal coordinate
    input [8:0] i_y,     // vertical coordinate
    input [12:0] status, // led status
    input i_clk,         // clock
    output [4:0] o_r,    // red component
    output [5:0] o_g,    // green component
    output [4:0] o_b     // blue component
);


// Read from Memory

wire false = 1'b0;
wire true = 1'b1;

wire [9:0] rom_addr = {i_y[4:0], i_x[4:0]}; // 32x32=1024
wire [15:0] rom_on_out;
wire [15:0] rom_off_out;

wire [15:0] rgb; // composite RGB565 color from ROM
assign o_r = rgb[15:11];
assign o_g = rgb[10:5];
assign o_b = rgb[4:0];


rom_led_on rom_led_on(
    .ad       (rom_addr),    //input [9:0] address
    .clk      (i_clk),
    .dout     (rom_on_out),
    .oce      (true),
    .ce       (true),
    .reset    (false)
);

rom_led_off rom_led_off(
    .ad       (rom_addr),    //input [9:0] address
    .clk      (i_clk),
    .dout     (rom_off_out),
    .oce      (true),
    .ce       (true),
    .reset    (false)
);


assign rgb = i_x < 32   ? 0 :
             i_x > 448  ? 0 :
             i_y < 96   ? 0 :
             i_y > 128  ? 0 :
             status[5] ? rom_on_out : rom_off_out;

endmodule
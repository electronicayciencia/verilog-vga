// Select the proper 32x32 16bit texture between 4 available
module sprites (
    input [8:0] i_x,     // horizontal coordinate
    input [8:0] i_y,     // vertical coordinate
    input [12:0] status, // led status
    input i_clk,         // clock
    output [4:0] o_r,    // red component
    output [5:0] o_g,    // green component
    output [4:0] o_b     // blue component
);

wire false = 1'b0;
wire true = 1'b1;

// work with 32x32 blocks (cells)
// bits 0-4 set the inner cell position, bit 5-8 set the cell number
wire [3:0] x = i_x[8:5];
wire [3:0] y = i_y[8:5];
wire [9:0] rom_addr = {i_y[4:0], i_x[4:0]}; // 32x32=1024


wire [15:0] rom_on_out;
wire [15:0] rom_off_out;
wire [15:0] rom_texture0_out;
wire [15:0] rom_texture1_out;


reg [15:0] rgb_temp; // temporary RGB565 color from ROM (with black holes)
wire [15:0] rgb;     // RGB565 color from ROM (with black replaced by default texture)
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

texture0_rom texture0_rom(
    .ad       (rom_addr),    //input [9:0] address
    .clk      (i_clk),
    .dout     (rom_texture0_out),
    .oce      (true),
    .ce       (true),
    .reset    (false)
);

texture1_rom texture1_rom(
    .ad       (rom_addr),    //input [9:0] address
    .clk      (i_clk),
    .dout     (rom_texture1_out),
    .oce      (true),
    .ce       (true),
    .reset    (false)
);



always @(*) begin
    // leds are in line 3
    if (y == 3 & x >= 1 & x <= 13)
        rgb_temp <= status[13-x] ? rom_on_out : rom_off_out;

    // alternate texture
    else if ( y < 2 | y > 4)
        rgb_temp <= rom_texture1_out;

    // default texture
    else
        rgb_temp <= rom_texture0_out;
end

// Replace black with default texture
assign rgb = |rgb_temp ? rgb_temp : rom_texture0_out;


endmodule

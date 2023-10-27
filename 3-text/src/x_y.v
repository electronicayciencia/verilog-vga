// Decouple character coordinates and text position from X/Y signals of hsync/vsync
module x_y (
    input i_clk,
    input i_hsync,
    input i_vsync,
    input i_lcden,
    output o_pxen,             // pixel is part of any cell
    output reg [2:0] o_char_x,
    output reg [2:0] o_char_y,
    output reg [10:0] o_cellnum
);

localparam [2:0] max_char_x = 7;
localparam [2:0] max_char_y = 7;

localparam [3:0] max_cell_x = 8;
localparam [3:0] max_cell_y = 8;

reg [3:0] xcounter;   // horizontal position inside cell
reg [3:0] ycounter;   // vertical   position inside cell

reg [12:0] x; //remove
reg [12:0] y; //remove


always @(negedge i_clk) begin
    if (i_hsync) begin
        xcounter <= 0;
        o_char_x <= 0;
        x <= 0;
    end
    else begin
        if (i_lcden) begin
            xcounter <= (xcounter == max_cell_x) ? 1'b0 : xcounter + 1'b1;
            o_char_x <= (xcounter <= max_char_x) ? xcounter[2:0] : max_char_x;
            x <= x+1'b1;
        end
    end
end

always @(posedge i_hsync) begin
    if (i_vsync) begin
        ycounter <= 0;
        o_char_y <= 0;
        y <= 0;
    end
    else begin
        ycounter <= (ycounter == max_cell_y) ? 1'b0 : ycounter + 1'b1;
        o_char_y <= (ycounter <= max_char_y) ? ycounter[2:0] : max_char_y;
        y <= y+1'b1;
    end
end

assign o_pxen = y == 2; // xcounter <= max_char_x & ycounter <= max_char_y; 

endmodule
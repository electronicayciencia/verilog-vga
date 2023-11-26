// Scroll a square section one line up.
// Leave the cursor in the bottom rigth corner.
module scroll (
    input i_clk,
    input i_start,             // assert high to start scrolling
    output        o_running,   // busy
    output [10:0] o_vram_addr,
    output        o_vram_w,
    output        o_vram_ce,
    input   [7:0] i_vram_dout,
    output  [7:0] o_vram_din
);

localparam [4:0] first_line = 0;
localparam [5:0] first_col  = 0;

localparam [4:0] last_line = 16;
localparam [5:0] last_col  = 59;

localparam false = 1'b0;
localparam true = 1'b1;


reg [4:0] row;
reg [5:0] col;
reg running = false;
reg writing = false;

assign o_running = running;

// end condition: write char from the bottom-right to the upper row
wire stop = (writing & row == last_line & col == last_col);

// write to row/col, read from row+1/col except if row is the last row
assign o_vram_addr = writing ? {row, col} :
                   row == last_line ? {row, col} :
                   {row+1'b1, col};

assign o_vram_din  = row == last_line ? 0 : i_vram_dout;
assign o_vram_w    = running & writing;
assign o_vram_ce   = running;

wire [5:0] next_col = col == last_col ?  first_col : col + 1'b1;
wire [4:0] next_row = col == last_col ? row + 1'b1 : row;

always @(negedge i_clk) begin
    if (i_start & ~running) begin
        row <= first_line;
        col <= first_col;
        running <= true;
        writing <= false;
    end

    else if (stop & running) begin
        running <= false;
    end

    else if (running) begin
        if (writing) begin
            col <= next_col;
            row <= next_row;
        end

        writing <= ~writing;
    end
end

endmodule
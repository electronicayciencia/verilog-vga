// Generate blinking cursor
module cursor (
    input i_vsync,              // frame clock
    input [5:0] i_wr_cell_x,    // x coordinate of the writing cell
    input [4:0] i_wr_cell_y,    // y coordinate of the writing cell
    input [5:0] i_cell_x,       // x coordinate of the cell being drawn
    input [4:0] i_cell_y,       // x coordinate of the cell being drawn
    input [3:0] i_char_y,       // y coordinate of the line being drawn
    input [3:0] i_h,            // cursor height in lines (0 = bottom, 15 = full)
    output o_cursor             // cursor pixel status
);


// Blink every X frames
reg [4:0] ctr;
always @(posedge i_vsync)
    ctr <= ctr + 1'b1;

// Highlight bottom lines of the cell to write
assign o_cursor = ctr[4] &                   // blinking
                (i_wr_cell_x == i_cell_x) & // same cell X
                (i_wr_cell_y == i_cell_y) & // same cell Y
                (i_char_y >= (15 - i_h));   // bottom lines


endmodule
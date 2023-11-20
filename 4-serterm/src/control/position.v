/********************************/
/* Cursor movement controler
/*   Assign "row" and "col".
/********************************/
module position (
    input i_clk,
    input i_cmd_home,     // set the cursor at 0,0
    input i_cmd_advance,  // advance the cursor, with automargin, no scroll
    output o_last_row,    // advert this is the last row
    output o_last_col,    // advert this is the last column
    output reg [4:0] o_row = last_row,
    output reg [5:0] o_col = first_col
);

parameter first_col = 0;
parameter first_row = 0;
parameter last_col = 59;
parameter last_row = 16;

assign o_last_row = o_row == last_row;
assign o_last_col = o_col == last_col;

always @(posedge i_clk) begin
    if (i_cmd_home) begin
        o_col <= first_col;
        o_row <= first_row;
    end
    else if (i_cmd_advance) begin
        if (o_col == last_col) begin
            o_col <= first_col;
            o_row <= o_row == last_row ? o_row : o_row + 1'b1;
        end
        else begin
            o_col <= o_col + 1'b1;
        end
    end
end


endmodule
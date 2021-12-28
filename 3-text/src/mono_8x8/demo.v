// Demo for obsessively writing text to the RAM
module demo (
    input i_clk,
    output reg [11:0] o_address,
    output reg [7:0] o_data,
    output reg o_we
);

localparam maxcol = 59;
localparam maxlin = 33;

//localparam len = 10;
//localparam [len*8-1:0] text = "Nevermore\n";
localparam len = 46;
localparam [len*8-1:0] text = "All work and no play makes Jack a dull boy.\n  ";


reg [6:0] idx = 0;  // text index (from 0 to len)
reg [5:0] col = 0;  // horizontal position (from 0 to maxcol)
reg [5:0] lin = 0;  // vertical position (from 0 to maxlin)

wire [7:0] chr = text[8*(len-idx-1) +: 8]; // current character
wire printable = chr >= 8'h20;             // is printable or control char?

reg [4:0] counter = 0;        // Waiting timer counter
wire slowclock = counter[1];  // derived slow clock

// wrap counters
wire [5:0] next_lin = lin == maxlin ? 1'b0 : lin + 1'b1;
wire [6:0] next_idx = idx == len-1 ? 1'b0 : idx + 1'b1;

always @(posedge i_clk)
    counter <= counter + 1'b1;


always @(posedge slowclock) begin
    o_address <= {lin, col};
    o_data    <= chr;
    o_we      <= printable;

    // update text position
    idx <= next_idx;

    // update screen position
    if (chr == 8'h0A) begin
        col <= col;
        lin <= next_lin;
    end
    else begin
        if (col == maxcol) begin
            col <= 0;
            lin <= next_lin;
        end
        else begin
            col <= col + 1'b1;
            lin <= lin;
        end
    end
end

endmodule
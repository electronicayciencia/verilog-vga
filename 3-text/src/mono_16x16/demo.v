// Demo for 16x16 monochrome text writing to RAM
// like a counter or something "simple"
module demo (
    input [12:0] i_status,
    input i_clk,
    output [9:0] o_address,
    output [7:0] o_data
);

localparam x_offset = 5'd3;
localparam y_offset = 5'd3;
localparam elements = 13; // i_status is 12 bits

reg [3:0] element = 0; // 16 text characters max

assign o_address = {y_offset, x_offset+element};
assign o_data = i_status[elements-element-1] ? 8'h31 : 8'h30;

always @(posedge i_clk) begin
    if (element == elements-1)
        element <= 0;
    else
        element <= element + 1'b1;
end

endmodule
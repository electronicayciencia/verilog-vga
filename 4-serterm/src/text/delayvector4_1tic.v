// Delay a vector 4, 1 clock cycle
module delayvector4_1tic (
    input clk,
    input [3:0] in,
    output reg [3:0] out
);

always @(posedge clk) begin
    out <= in;
end

endmodule

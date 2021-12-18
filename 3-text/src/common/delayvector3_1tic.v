// Delay a vector 3, 1 clock cycle
module delayvector3_1tic (
    input clk,
    input [2:0] in,
    output reg [2:0] out
);

always @(posedge clk) begin
    out <= in;
end

endmodule

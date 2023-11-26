// Delay a bit signal 2 clock cycles
// version with temporary variable to show how non-blocking assignments work
module delaybit_2tic (
    input clk,
    input in,
    output reg out
);

reg tmp;

always @(posedge clk) begin
    tmp <= in;
    out <= tmp;
end

endmodule

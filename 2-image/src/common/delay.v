// Delay a signal 1 clock cycle
module delay (
    input clk,
    input in,
    output reg out
);

always @(posedge clk) 
    out <= in;

endmodule

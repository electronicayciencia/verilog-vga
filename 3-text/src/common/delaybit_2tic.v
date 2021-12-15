// Delay a bit signal 2 clock cycles
module delaybit_2tic (
    input clk,
    input in,
    output out
);

reg [1:0] d = 0;
assign out = d[1];

always @(posedge clk) 
    d <= {d[0], in};

endmodule

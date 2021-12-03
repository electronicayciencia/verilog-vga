module delay (
    input clk,
    input in,
    output out
);

reg [5:0] S;
assign out = S[0]; // how many cycles - 1?

always @(posedge clk) 
    S <= {S[4:0], in};

endmodule

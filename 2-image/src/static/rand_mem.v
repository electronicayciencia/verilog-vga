// Use a Galois LFSR to fill memory with random bits
// https://www.xilinx.com/support/documentation/application_notes/xapp052.pdf
module rand_mem(
    input i_clk,      // clock
    output reg [15:0] o_addr = 0, // memory address to write into
    output o_dat      // data to write
);

reg [31:0] l = 32'h1;
assign o_dat = l[31];

always @(posedge i_clk) begin
    o_addr <= o_addr + 1'b1;

    l <= {l[30:0], l[31] ^ l[21] ^ l[1] ^ l[0]};
end

endmodule

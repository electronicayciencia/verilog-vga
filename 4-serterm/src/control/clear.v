// Zero the screen memory.
// Leave the cursor in the last memory position.
module clear (
    input i_clk,
    input i_start,             // assert high to start cleaning
    output reg    o_running = 0,   // busy
    output [10:0] o_vram_addr,
    output        o_vram_w,
    output        o_vram_ce,
    output  [7:0] o_vram_din
);

parameter [10:0] first_addr = 11'b00000_000000;
parameter [10:0] last_addr  = 11'b11111_111111;
parameter  [7:0] filling = 8'b0;

localparam false = 1'b0;
localparam true = 1'b1;

reg [10:0] addr = 0;

always @(negedge i_clk) begin
    if (i_start) begin
        addr <= first_addr;
        o_running <= true;
    end
    else if (addr == last_addr) begin
        o_running <= false;
    end
    else begin
        addr <= o_vram_addr + 1'b1;
    end
end


assign o_vram_addr = addr;
assign o_vram_din  = filling;
assign o_vram_w    = o_running;
assign o_vram_ce   = o_running;

endmodule
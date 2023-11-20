// Put character, advance cursor, scroll if needed
module putchar (
    input i_clk,
    input i_start,             // assert high to set the char
    input i_cursorend,         // true if this is the bottom right end
    input [7:0]   i_char,
    output reg    o_advance,   // inform position module to update cursor
    output reg    o_scroll,    // inform scroll module to scroll up
    output reg    o_running,   // take vram lines
    output reg    o_vram_w,
    output reg    o_vram_ce,
    output [7:0]  o_vram_din
);

parameter false = 1'b0;
parameter true = 1'b1;

assign o_vram_din = i_char;

reg need_scroll = false;

always @(posedge i_clk) begin
    // putchar & scroll cannot be sone at the same time
    // delay the scroll one clock pulse
    if (need_scroll) begin
        o_scroll <= true;
        need_scroll <= false;
    end

    if (o_scroll) begin
        o_scroll <= false;
    end

    if (i_start) begin
        o_vram_ce <= true;
        o_vram_w <= true;
        o_running <= true;
        o_advance <= true;
        if (i_cursorend)
            need_scroll <= true;

    end
    else begin
        o_vram_ce <= false;
        o_vram_w <= false;
        o_running <= false;
        o_advance <= false;
    end
end

endmodule

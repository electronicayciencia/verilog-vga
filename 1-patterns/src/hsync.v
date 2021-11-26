module hsync (
    input  i_clk,
    output reg o_hsync,
    output reg o_hde,
    output reg [8:0] o_x
);


localparam hactive      = 480;
localparam hback_porch  = 2;
localparam hsync_len    = 41;
localparam hfront_porch = 2;

localparam maxcount  = hactive + hfront_porch + hsync_len + hback_porch;
localparam syncstart = hactive + hfront_porch;
localparam syncend   = syncstart + hsync_len;

reg [9:0] counter = 0;

always @(posedge i_clk) begin
    if (counter == maxcount - 1)
        counter <= 0;
    else
        counter <= counter + 1'b1;

    o_hsync <= ~(counter >= syncstart & counter < syncend);
    o_x     <= counter[8:0];
    o_hde   <= (counter < hactive);
end

endmodule
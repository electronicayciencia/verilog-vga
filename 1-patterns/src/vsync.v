module vsync (
    input  i_clk,
    output reg o_vsync,
    output reg o_vde,
    output reg [8:0] o_y
);

localparam vactive      = 272;
localparam vback_porch  = 2;
localparam vsync_len    = 10;
localparam vfront_porch = 2;

localparam maxcount  = vactive + vfront_porch + vsync_len + vback_porch;
localparam syncstart = vactive + vfront_porch;
localparam syncend   = syncstart + vsync_len;

reg [9:0] counter = 0;

always @(posedge i_clk) begin
    if (counter == maxcount - 1)
        counter <= 0;
    else
        counter <= counter + 1'b1;

    o_vsync <= ~(counter >= syncstart & counter < syncend);
    o_y     <= counter[8:0];
    o_vde   <= (counter < vactive);
end

endmodule

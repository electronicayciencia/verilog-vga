module vsync (
    input  i_clk,
    output o_vsync,
    output o_vde,
    output [8:0] o_y
);

localparam vactive      = 272;
localparam vfront_porch = 4;
localparam vsync_len    = 10;
localparam vback_porch  = 4;

localparam maxcount  = vactive + vfront_porch + vback_porch + vsync_len;
localparam syncstart = vactive + vback_porch;
localparam syncend   = syncstart + vsync_len;

reg [9:0] counter = 0;

always @(posedge i_clk) begin
    if (counter == maxcount - 1)
        counter <= 0;
    else
        counter <= counter + 1'b1;
end

assign o_y     = counter[8:0];
assign o_vde   = (counter < vactive);
assign o_vsync = ~(counter >= syncstart & counter < syncend);

endmodule

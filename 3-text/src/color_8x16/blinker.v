// Generate blinking line
// VGA blinks every 16 frames (1.8Hz @ 60Hz)
module blinker (
    input      i_vsync, // frame
    output     o_bl     // blinking line
);

reg [4:0] counter;

assign o_bl = counter[4];

always @(negedge i_vsync)
    counter <= counter + 1'b1;

endmodule
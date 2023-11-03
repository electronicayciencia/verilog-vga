// Generate blinking line
// VGA blinks every 16 frames (1.8Hz @ 60Hz)
module blinker (
    input      i_vsync, // frame
    output reg o_bl     // blinking line
);

reg [3:0] counter;

always @(negedge i_vsync) begin
    counter <= counter + 1'b1;

    if (counter == 0)
        o_bl <= ~o_bl;
end

endmodule
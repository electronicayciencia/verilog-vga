// Condition a push button
// Fires just after pushing it, then repeat with a fixed interval
module push_button (
    input i_btn,           // button active high
    input [31:0] i_delay,  // [31:0] ticks to wait for repeat
    input i_clk,
    output reg o_pulse     // output is high for 1 tick
);

reg [31:0] counter = 0;

always @(negedge i_clk) begin
    if (i_btn) begin
        if (counter == 0) begin
            o_pulse <= 1;
            counter <= i_delay;
        end
        else begin
            o_pulse <= 0;
            counter <= counter == 0 ? 0 : counter - 1'b1;
        end
    end
    else begin
        counter <= counter == 0 ? 0 : counter - 1'b1;
        o_pulse <= 0;
    end
end

endmodule
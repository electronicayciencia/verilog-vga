// Show multiple patterns sequentially
module patterns (
    input [8:0] i_x,
    input [8:0] i_y,
    input i_clk,
    output [4:0] o_R,
    output [5:0] o_G,
    output [4:0] o_B
);

wire [4:0] pat0_R;
wire [5:0] pat0_G;
wire [4:0] pat0_B;

pat_fixed pattern0 (
    .i_x       (i_x),
    .i_y       (i_y),
    .o_R       (pat0_R),
    .o_G       (pat0_G),
    .o_B       (pat0_B)
);

wire [4:0] pat1_R;
wire [5:0] pat1_G;
wire [4:0] pat1_B;

pat_edge pattern1 (
    .i_x       (i_x),
    .i_y       (i_y),
    .o_R       (pat1_R),
    .o_G       (pat1_G),
    .o_B       (pat1_B)
);

wire [4:0] pat2_R;
wire [5:0] pat2_G;
wire [4:0] pat2_B;

pat_checkboard pattern2 (
    .i_x       (i_x),
    .i_y       (i_y),
    .o_R       (pat2_R),
    .o_G       (pat2_G),
    .o_B       (pat2_B)
);

wire [4:0] pat3_R;
wire [5:0] pat3_G;
wire [4:0] pat3_B;

pat_gradient pattern3 (
    .i_x       (i_x),
    .i_y       (i_y),
    .o_R       (pat3_R),
    .o_G       (pat3_G),
    .o_B       (pat3_B)
);

reg [1:0] pat_number = 0; // four patterns demo
reg [8:0] counter = 0;    // frame counter

always @(posedge i_clk) begin
    if (counter == 480) begin
        pat_number <= pat_number + 1'b1;
        counter <= 0;
    end
    else
       counter <= counter + 1'b1;
end


assign o_R = pat_number == 0 ? pat0_R :
             pat_number == 1 ? pat1_R :
             pat_number == 2 ? pat2_R :
             pat_number == 3 ? pat3_R : 0;

assign o_G = pat_number == 0 ? pat0_G :
             pat_number == 1 ? pat1_G :
             pat_number == 2 ? pat2_G :
             pat_number == 3 ? pat3_G : 0;

assign o_B = pat_number == 0 ? pat0_B :
             pat_number == 1 ? pat1_B :
             pat_number == 2 ? pat2_B :
             pat_number == 3 ? pat3_B : 0;

endmodule

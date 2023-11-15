module top (
    input XTAL_IN,       // 24 MHz
    output [4:0] LCD_R,
    output [5:0] LCD_G,
    output [4:0] LCD_B,
    output LCD_HSYNC,
    output LCD_VSYNC,
    output LCD_CLK,
    output LCD_DEN,
    input BTN_A,
    output LED_R,
    output LED_G,
    output LED_B
);

wire false = 1'b0;
wire true = 1'b1;


wire vram_w;
wire vram_ce;
wire [10:0] vram_addr;
wire  [7:0] vram_dout;
wire  [7:0] vram_din;


/* Generate LCD output for the text and cursor
   Provides the interface for write into the VRAM */
text text(
    .i_clk          (XTAL_IN),  // Clock (24 MHz)

    // VRAM port: for upper controller
    .i_vram_addr    (vram_addr),// VRAM address {5'y, 6'x}
    .i_vram_din     (vram_din), // VRAM data in
    .i_vram_dout    (vram_dout),// VRAM data out
    .i_vram_ce      (vram_ce),  // VRAM clock enable
    .i_vram_wre     (vram_w),   // VRAM write / read

    // Cursor options
    .i_cursor_e     (true),     // Cursor enable
    .i_cursor_h     (4'd1),     // cursor lines (0 = bottom, 15 = full)

    // LCD signals
    .o_LCD_R        (LCD_R),    // LCD red
    .o_LCD_G        (LCD_G),    // LCD green
    .o_LCD_B        (LCD_B),    // LCD blue
    .o_LCD_HSYNC    (LCD_HSYNC),// LCD horizontal sync
    .o_LCD_VSYNC    (LCD_VSYNC),// LCD vertical sync
    .o_LCD_CLK      (LCD_CLK),  // LCD clock
    .o_LCD_DEN      (LCD_DEN)   // LCD data enable
);


reg [32:0] ctr;
wire slowclock = ctr[10];
always @(negedge XTAL_IN)
    ctr = ctr + 1'b1;

reg [4:0] row = 5;
reg [5:0] col = 5;


assign LED_G = ~(~running);
assign LED_B = ~(running & ~writing);
assign LED_R = ~(running & writing);




// Scroll
localparam [4:0] first_line = 0;
localparam [5:0] first_col  = 0;

localparam [4:0] last_line = 17;
localparam [5:0] last_col  = 60;

reg running = 0;
reg writing = 0;



// write to row/col, read from row+1/col except if row is the last row
assign vram_addr = writing ? {row, col} :
                   row == last_line - 1 ? {row, col} :
                   {row+1, col};

assign vram_din  = row == last_line - 1 ? 0 : vram_dout;
assign vram_w    = running & writing;
assign vram_ce   = running;

wire start = ~BTN_A;
// end condition: write char from the bottom-right to the upper row
wire stop = (running & writing & row == last_line - 1 & col == last_col - 1);

wire [5:0] next_col = col != last_col - 1 ? col + 1'b1 : first_col;
wire [4:0] next_row = col != last_col - 1 ? row : row + 1'b1;

always @(negedge slowclock) begin
    if (start & ~running) begin
        row <= first_line;
        col <= first_col;
        running <= true;
        writing <= false;
    end

    else if (stop & running) begin
        running <= false;
    end

    else if (running) begin
        if (writing) begin
            col <= next_col;
            row <= next_row;
        end

        writing <= ~writing;
    end
end


endmodule
module top (
    input XTAL_IN,       // 24 MHz
    output [4:0] LCD_R,
    output [5:0] LCD_G,
    output [4:0] LCD_B,
    output LCD_HSYNC,
    output LCD_VSYNC,
    output LCD_CLK,
    output LCD_DEN,
//    output LED_R,
//    output LED_G,
//    output LED_B,
    input BTN_A,
    input BTN_B
);

localparam false = 1'b0;
localparam true = 1'b1;



wire CLK_12MHZ;

// Use 24/2 = 12MHz for LCD and system clock.
clk_div clk_div (
    .i_clk(XTAL_IN),
    .i_factor(5'd0),     // 0: /2,  1: /4,  2: /8 ...
    .o_clk(CLK_12MHZ)
);

parameter first_col = 0;
parameter first_row = 0;
parameter last_col = 59;
parameter last_row = 16;

localparam char = 8'h41;

reg [4:0] row = last_row;
reg [5:0] col = first_col;


wire clearhome_start;

reg scroll_start = false;
wire scroll_running;

reg clear_start = false;
wire clear_running;



push_button m_BTN_A (
    .i_btn   (~BTN_A),       // button active high
    .i_delay (0_200_000),    // [31:0] ticks to wait for repeat
    .i_clk   (CLK_12MHZ),
    .o_pulse (putchar_start) // output is high for 1 tick
);

push_button m_BTN_B (
    .i_btn   (~BTN_B),       // button active high
    .i_delay (2_000_000),    // [31:0] ticks to wait for repeat
    .i_clk   (CLK_12MHZ),
    .o_pulse (clearhome_start)  // output is high for 1 tick
);


/********************************/
/* Put character and advance cursor
/********************************/
reg putchar_running; // reclaim vram lines.
reg [7:0] putchar_vram_din = char;
reg putchar_vram_ce;
reg putchar_vram_w;

reg putchar_cursor_advance = false;

always @(posedge CLK_12MHZ) begin
    if (putchar_start) begin
        putchar_vram_ce <= true;
        putchar_vram_w <= true;
        putchar_running <= true;
        putchar_cursor_advance <= true;
    end
    else begin
        putchar_vram_ce <= false;
        putchar_vram_w <= false;
        putchar_running <= false;
        putchar_cursor_advance <= false;
    end
end


/********************************/
/* Clear the screen and home cursor
/********************************/
reg clearhome_running = false;
reg clearhome_cursorhome = false; // to indicate homing the cursor

always @(posedge CLK_12MHZ) begin
    if (clearhome_start) begin
        clearhome_running <= true;
        clear_start <= true;
    end
    
    if (clearhome_running) begin
        if (clear_running) begin
            clear_start <= false;
            clearhome_running <= false;
            clearhome_cursorhome <= true;
        end
    end
    else begin
        clearhome_cursorhome <= false;
    end
end


/********************************/
/* Cursor movement controler
/*   Assign "row" and "col".
/********************************/
localparam 
    IDLE = 0,    // don't touch the cursor
    ADVANCE = 1, // advance one position, scroll if needed
    HOME = 2;    // set to first row and first col

reg [1:0] cursor_move = IDLE;

always @(posedge CLK_12MHZ) begin
    if (putchar_cursor_advance) cursor_move <= ADVANCE;
    if (clearhome_cursorhome)   cursor_move <= HOME;
    if (scroll_start)           scroll_start <= false;

    if (cursor_move == ADVANCE) begin
        cursor_move <= IDLE;
        if (col == last_col) begin
            col <= first_col;
            if (row == last_row) begin
                scroll_start <= true;
            end
            else begin
                row <= row + 1'b1;
            end
        end
        else begin
            col <= col + 1'b1;
        end
    end
    else if (cursor_move == HOME) begin
        cursor_move <= IDLE;
        col <= first_col;
        row <= first_row;
    end

end




/********************************/
/* Modules and control
/********************************/

// Default values for vram lines
reg vram_w  = false;
reg vram_ce = false;
wire [10:0] vram_addr = {row, col};
wire  [7:0] vram_din = false;


// VRAM lines are shared between all modules
wire        common_vram_w,
            scroll_vram_w,
            clear_vram_w;

wire        common_vram_ce,
            scroll_vram_ce, 
            clear_vram_ce;

wire [10:0] common_vram_addr, 
            scroll_vram_addr, 
            clear_vram_addr;

wire  [7:0] common_vram_dout, 
            scroll_vram_dout, 
            clear_vram_dout;

wire  [7:0] common_vram_din, 
            scroll_vram_din, 
            clear_vram_din;


// When a module is active, it takes the VRAM wires over idle signals
assign common_vram_w    = scroll_running  ? scroll_vram_w : 
                          clear_running   ? clear_vram_w : 
                          putchar_running ? putchar_vram_w : 
                          vram_w;

assign common_vram_ce   = scroll_running  ? scroll_vram_ce : 
                          clear_running   ? clear_vram_ce : 
                          putchar_running ? putchar_vram_ce : 
                          vram_ce;

assign common_vram_addr = scroll_running  ? scroll_vram_addr :
                          clear_running   ? clear_vram_addr : 
                          vram_addr;

assign common_vram_din  = scroll_running  ? scroll_vram_din :
                          clear_running   ? clear_vram_din : 
                          putchar_running ? putchar_vram_din : 
                          vram_din;

assign scroll_vram_dout = scroll_running ? common_vram_dout : false;


scroll scroll_m(
    .i_clk          (CLK_12MHZ),
    .i_start        (scroll_start),     // assert high to start scrolling
    .o_running      (scroll_running),   // busy
    .o_vram_addr    (scroll_vram_addr),
    .o_vram_w       (scroll_vram_w),
    .o_vram_ce      (scroll_vram_ce),
    .i_vram_dout    (scroll_vram_dout),
    .o_vram_din     (scroll_vram_din)
);


clear clear_m(
    .i_clk          (CLK_12MHZ),
    .i_start        (clear_start),     // assert high to start cleaning
    .o_running      (clear_running),   // busy
    .o_vram_addr    (clear_vram_addr),
    .o_vram_w       (clear_vram_w),
    .o_vram_ce      (clear_vram_ce),
    .o_vram_din     (clear_vram_din)
);



/* Generate LCD output for the text and cursor
   Provides the interface for write into the VRAM */
text text(
    .i_clk          (CLK_12MHZ),  // Clock (12 MHz)

    // VRAM port: for upper controller
    .i_vram_clk     (CLK_12MHZ),         // VRAM clock
    .i_vram_addr    (common_vram_addr),  // VRAM address {5'y, 6'x}
    .i_vram_din     (common_vram_din),   // VRAM data in
    .i_vram_dout    (common_vram_dout),  // VRAM data out
    .i_vram_ce      (common_vram_ce),    // VRAM clock enable
    .i_vram_wre     (common_vram_w),     // VRAM write / read

    // Cursor options
    .i_cursor_e     (true),       // Cursor enable
    .i_cursor_h     (4'd1),       // cursor lines (0 = bottom, 15 = full)

    // LCD signals
    .o_LCD_R        (LCD_R),      // LCD red
    .o_LCD_G        (LCD_G),      // LCD green
    .o_LCD_B        (LCD_B),      // LCD blue
    .o_LCD_HSYNC    (LCD_HSYNC),  // LCD horizontal sync
    .o_LCD_VSYNC    (LCD_VSYNC),  // LCD vertical sync
    .o_LCD_CLK      (LCD_CLK),    // LCD clock
    .o_LCD_DEN      (LCD_DEN)     // LCD data enable
);



endmodule




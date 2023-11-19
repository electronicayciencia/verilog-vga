// Provides basic services to interact with the text hardware
module control (
    input        i_clk,       // 12 MHz please
    input        i_clearhome, // pulse to do clearhome
    input        i_putchar,   // pulse to do putchar
    input  [7:0] i_char,      // char to put
    output [4:0] o_LCD_R,
    output [5:0] o_LCD_G,
    output [4:0] o_LCD_B,
    output       o_LCD_HSYNC,
    output       o_LCD_VSYNC,
    output       o_LCD_CLK,
    output       o_LCD_DEN
);


parameter false = 1'b0;
parameter true = 1'b1;


wire [4:0] row;
wire [5:0] col;


wire clearhome_start = i_clearhome;
wire putchar_start   = i_putchar;

reg scroll_start = false;
wire scroll_running;

reg clear_start = false;
wire clear_running;


/********************************/
/* Put character and advance cursor
/********************************/
reg putchar_running; // reclaim vram lines.
wire [7:0] putchar_vram_din = i_char;
reg putchar_vram_ce;
reg putchar_vram_w;

reg putchar_cursor_advance = false;

always @(posedge i_clk) begin
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

always @(posedge i_clk) begin
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


position position(
    .i_clk         (i_clk),
    .i_cmd_home    (clearhome_cursorhome),
    .i_cmd_advance (putchar_cursor_advance),
    .o_row         (row),
    .o_col         (col)
);



/********************************/
/* Modules and control
/********************************/

// Default values for vram lines
wire vram_w  = false;
wire vram_ce = false;
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
    .i_clk          (i_clk),
    .i_start        (scroll_start),     // assert high to start scrolling
    .o_running      (scroll_running),   // busy
    .o_vram_addr    (scroll_vram_addr),
    .o_vram_w       (scroll_vram_w),
    .o_vram_ce      (scroll_vram_ce),
    .i_vram_dout    (scroll_vram_dout),
    .o_vram_din     (scroll_vram_din)
);


clear clear_m(
    .i_clk          (i_clk),
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
    .i_clk          (i_clk),  // Clock (12 MHz)

    // VRAM port: for upper controller
    .i_vram_clk     (i_clk),         // VRAM clock
    .i_vram_addr    (common_vram_addr),  // VRAM address {5'y, 6'x}
    .i_vram_din     (common_vram_din),   // VRAM data in
    .i_vram_dout    (common_vram_dout),  // VRAM data out
    .i_vram_ce      (common_vram_ce),    // VRAM clock enable
    .i_vram_wre     (common_vram_w),     // VRAM write / read

    // Cursor options
    .i_cursor_e     (true),       // Cursor enable
    .i_cursor_h     (4'd1),       // cursor lines (0 = bottom, 15 = full)

    // LCD signals
    .o_LCD_R        (o_LCD_R),      // LCD red
    .o_LCD_G        (o_LCD_G),      // LCD green
    .o_LCD_B        (o_LCD_B),      // LCD blue
    .o_LCD_HSYNC    (o_LCD_HSYNC),  // LCD horizontal sync
    .o_LCD_VSYNC    (o_LCD_VSYNC),  // LCD vertical sync
    .o_LCD_CLK      (o_LCD_CLK),    // LCD clock
    .o_LCD_DEN      (o_LCD_DEN)     // LCD data enable
);

endmodule
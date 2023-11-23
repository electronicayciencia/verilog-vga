/*
This is the abstraction layer to interact with the text hardware.

Valid/ready handshake.

Control characters:
- 0x00 NUL: do nothing.
- 0x08 BS:  move cursor 1 position to the right
- 0x0A LF:  move cursor 1 position down, scroll text if needed
- 0x0C FF:  clear the screen and home cursor
- 0x0D CR:  move the cursor to first position in the line

else: 
- put the char in the current position
- move cursor 1 position to the right
- if it is at the end of the line, move it to the first position of the next line (auto margin)
- scroll if needed

*/

module control (
    input        i_clk,       // 12 MHz please
    input  [7:0] i_char,      // char received
    input        i_valid,     // new char available
    output       o_ready,     // ready to get a char
    output [4:0] o_LCD_R,     // LCD lines
    output [5:0] o_LCD_G,
    output [4:0] o_LCD_B,
    output       o_LCD_HSYNC,
    output       o_LCD_VSYNC,
    output       o_LCD_CLK,
    output       o_LCD_DEN
);


parameter false = 1'b0;
parameter true = 1'b1;

parameter first_col = 0;
parameter first_row = 0;
parameter last_col = 59;
parameter last_row = 16;

reg [4:0] row = last_row;
reg [5:0] col;

reg [2:0] status = IDLE;

reg [7:0] char; // processing this char
assign o_ready = status == IDLE;


// Values for vram lines when no other module is running
reg  vram_w  = false;
reg  vram_ce = false;
wire [10:0] vram_addr = {row, col};
wire  [7:0] vram_din = char;
wire  [7:0] vram_dout;


/*
Ready / valid handshake
*/



/* 
Main controller.
This block interprets control characters.
*/
localparam NUL = 8'h00, // do nothing.
           BS  = 8'h08, // move cursor 1 position to the right
           LF  = 8'h0A, // move cursor 1 position down, scroll text if needed
           FF  = 8'h0C, // clear the screen and home cursor
           CR  = 8'h0D; // move the cursor to first position in the line


localparam IDLE       = 3'd0,  // done
           START      = 3'd1,  // new character
           WRITING    = 3'd2,  // write a character in the current position
           SCROLLING  = 3'd3,  // run the scroll module
           CLEARING   = 3'd4;  // run the clear module

reg scroll_start = 0; // to order a scroll

always @(posedge i_clk) begin
    if (status == IDLE) begin
        if (i_valid) begin
            char <= i_char;
            status <= START; // this de-asserts ready signal
        end
    end

    case (char)
        NUL:
            status <= IDLE;
            
        BS: begin
            if (status == START) begin
                if (col != first_col)
                    col <= col - 1'b1;
                status <= IDLE;
            end
        end

        // default is write character in teletype mode with auto-margin
        default:  begin
            case (status)
                START: begin
                    vram_w <= true;
                    vram_ce <= true;
                    status <= WRITING;
                end
                WRITING: begin
                    vram_w <= false;
                    vram_ce <= false;
                    if (col == last_col) begin
                        col <= first_col;
                        row <= row == last_row ? row : row + 1'b1;
                    end
                    else begin
                        col <= col + 1'b1;
                    end
                    if (row == last_row & col == last_col) begin
                        status <= SCROLLING;
                        scroll_start <= true;
                    end
                    else begin
                        status <= IDLE;
                    end
                end
                SCROLLING: begin
                    scroll_start <= false;
                    if (scroll_running)
                        status <= SCROLLING;
                    else
                        status <= IDLE;
                end
            endcase
        end

    endcase

end





//wire clearhome_start = i_clearhome;
//wire putchar_start   = i_putchar;

//wire scroll_start = putchar_scroll_start;
//wire scroll_running;

//reg clear_start = false;
//wire clear_running;


/********************************/
/* Put character and advance cursor
/********************************/
/*
wire position_last_col, position_last_row;
wire cursor_end = position_last_col & position_last_row;
wire [7:0] putchar_vram_din;
wire putchar_running,
     putchar_vram_ce,
     putchar_vram_w,
     putchar_cursor_advance,
     putchar_scroll_start,
     putchar_need_scroll;

putchar putchar (
    .i_clk       (i_clk),
    .i_start     (i_putchar),             // assert high to set the char
    .i_cursorend (cursor_end),
    .i_char      (i_char),
    .o_advance   (putchar_cursor_advance), // inform position module to update cursor
    .o_scroll    (putchar_scroll_start),   // inform scroll module to scroll up
    .o_running   (putchar_running),        // take vram lines
    .o_vram_w    (putchar_vram_w),
    .o_vram_ce   (putchar_vram_ce),
    .o_vram_din  (putchar_vram_din)
);
*/



/********************************/
/* Clear the screen and home cursor
/********************************/
/*
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
*/
/*
position position(
    .i_clk         (i_clk),
    .i_cmd_home    (clearhome_cursorhome),
    .i_cmd_advance (putchar_cursor_advance),
    .o_last_row    (position_last_row),
    .o_last_col    (position_last_col),
    .o_row         (row),
    .o_col         (col)
);
*/


/************************************/
/* Primitives and VRAM lines sharing
/************************************/

// VRAM lines are shared between all modules
reg         common_vram_w;
reg         common_vram_ce;
reg  [10:0] common_vram_addr;
reg   [7:0] common_vram_din;

wire        scroll_vram_w,
            clear_vram_w;

wire        scroll_vram_ce, 
            clear_vram_ce;

wire [10:0] scroll_vram_addr, 
            clear_vram_addr;

wire  [7:0] scroll_vram_din, 
            clear_vram_din;


// When a module is active, it is assigned the VRAM wires
always @(*) begin
    case(status)
        CLEARING: begin
            common_vram_w    <= clear_vram_w;
            common_vram_ce   <= clear_vram_ce;
            common_vram_addr <= clear_vram_addr;
            common_vram_din  <= clear_vram_din;
        end

        SCROLLING: begin
            common_vram_w    <= scroll_vram_w;
            common_vram_ce   <= scroll_vram_ce;
            common_vram_addr <= scroll_vram_addr;
            common_vram_din  <= scroll_vram_din;
        end

        default: begin
            common_vram_w    <= vram_w;
            common_vram_ce   <= vram_ce;
            common_vram_addr <= vram_addr;
            common_vram_din  <= vram_din;
        end

    endcase
end

/*
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
*/

scroll scroll_m(
    .i_clk          (i_clk),
    .i_start        (scroll_start),     // assert high to start scrolling
    .o_running      (scroll_running),   // busy
    .o_vram_addr    (scroll_vram_addr),
    .o_vram_w       (scroll_vram_w),
    .o_vram_ce      (scroll_vram_ce),
    .i_vram_dout    (vram_dout),
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
    .o_vram_dout    (vram_dout),         // VRAM data out
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
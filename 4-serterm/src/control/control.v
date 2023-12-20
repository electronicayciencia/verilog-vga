/*
This is the abstraction layer to interact with the text hardware.

Valid/ready handshake.

Some control characters:
    NUL = 8'h00, // do nothing.
    BEL = 8'h07, // do nothing
    BS  = 8'h08, // ^H move cursor 1 position to the right
    DEL = 8'h7F, // ^? move cursor 1 position to the right
    LF  = 8'h0A, // ^J move cursor 1 position down, scroll text if needed
    FF  = 8'h0C, // ^L clear the screen and home cursor
    CR  = 8'h0D; // ^M move the cursor to first position in the line
    DC4 = 8'h14; // ^T position the cursor at row / col

else: 
- put the char in the current position
- move cursor 1 position to the right
- if it is at the end of the line, move it to the first position of the next line (auto margin)
- scroll if needed

*/
module control (
    input         i_clk,       // 12 MHz please
    input         i_ectlchrs,  // enable control characters

    // Interface
    input   [7:0] i_char,      // char received
    input         i_valid,     // new char available
    output        o_ready,     // ready to get a char

    // VRAM handler
    output [10:0] o_vram_addr, // VRAM address {5'y, 6'x}
    output  [7:0] o_vram_din,  // VRAM data in
    input   [7:0] i_vram_dout, // VRAM data out
    output        o_vram_clk,  // VRAM clock
    output        o_vram_ce,   // VRAM clock enable
    output        o_vram_wre   // VRAM write/read
);


parameter false = 1'b0;
parameter true = 1'b1;

parameter first_col = 0;
parameter first_row = 0;
parameter last_col = 59;
parameter last_row = 16;

reg [4:0] row = first_row;
reg [5:0] col = first_col;

reg [2:0] status = IDLE;

reg [7:0] char; // processing this char
assign o_ready = (status == IDLE) | 
                 (status == WAIT_COL) |
                 (status == WAIT_ROW) ;


// Values for vram lines when no other module is running
reg vram_w  = false;
reg vram_ce = false;

assign o_vram_clk  = i_clk;
assign o_vram_wre  = common_vram_w;
assign o_vram_ce   = common_vram_ce;
assign o_vram_addr = common_vram_addr;
assign o_vram_din  = common_vram_din;

// add 20h to row/col number to prevent control codes
wire [7:0] i_char_nocontrol = i_char - 8'h20;
// tabs each 8 spaces
wire [7:0] next_tab = (col + 6'b001000) & 6'b111000;

/* 
Main controller.
This block interprets control characters.
*/
localparam NUL = 8'h00, // do nothing.
           BEL = 8'h07, // do nothing
           BS  = 8'h08, // ^H move cursor 1 position to the right
           HT  = 8'h09, // Tab move cursor col to the next multiple of 8
           DEL = 8'h7F, // move cursor 1 position to the right
           LF  = 8'h0A, // ^J move cursor 1 position down, scroll text if needed
           FF  = 8'h0C, // ^L clear the screen and home cursor
           CR  = 8'h0D, // ^M move the cursor to first position in the line
           DC4 = 8'h14; // ^T position the cursor at row / col

localparam IDLE       = 3'd0,  // done
           NEW        = 3'd1,  // new character
           WRITING    = 3'd2,  // write a character in the current position
           SCROLLING  = 3'd3,  // run the scroll module
           CLEARING   = 3'd4,  // run the clear module
           WAIT_ROW   = 3'd5,  // ^T received, waiting for row
           WAIT_COL   = 3'd6;  // ^T received, waiting for col

reg scroll_start = 0; // to order a scroll
reg clear_start  = 0; // to order a clearing

always @(posedge i_clk) begin
    case(status)

        IDLE: begin
            if (i_valid) begin
                char <= i_char;
                status <= NEW; // this de-asserts the ready signal
            end
        end

        WAIT_ROW: begin
            if (i_valid) begin
                status <= WAIT_COL;
                if (i_char_nocontrol[4:0] <= last_row)
                    row <= i_char_nocontrol[4:0]; 
                else
                    row <= last_row;
            end
        end

        WAIT_COL: begin
            if (i_valid) begin
                status <= IDLE;
                if (i_char_nocontrol[5:0] <= last_col)
                    col <= i_char_nocontrol[5:0];
                else
                    col <= last_col;
            end
        end

        default: begin
            case ({i_ectlchrs, char})
                {true, NUL},
                {true, BEL}: begin
                    if (status == NEW) begin
                        status <= IDLE;
                    end
                end

                {true, BS}, 
                {true, DEL}: begin
                    if (status == NEW) begin
                        if (col != first_col)
                            col <= col - 1'b1;
                        status <= IDLE;
                    end
                end


                {true, CR}: begin
                    if (status == NEW) begin
                        col <= first_col;
                        status <= IDLE;
                    end
                end


                {true, HT}: begin
                    if (status == NEW) begin
                        col <= (next_tab[5:0] <= last_col) ? next_tab[5:0] : last_col;
                        status <= IDLE;
                    end
                end


                {true, DC4}: begin
                    if (status == NEW) begin
                        status <= WAIT_ROW;
                    end
                end


                {true, LF}: begin
                    case (status)
                    NEW: begin
                        if (row == last_row) begin
                            status <= SCROLLING;
                            scroll_start <= true;
                        end
                        else begin
                            row <= row + 1'b1;
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


                {true, FF}: begin
                    case (status)
                        NEW: begin
                            row <= first_row;
                            col <= first_col;
                            clear_start <= true;
                            status <= CLEARING;
                        end
                        CLEARING: begin
                            clear_start <= false;
                            if (clear_running)
                                status <= CLEARING;
                            else
                                status <= IDLE;
                        end
                    endcase
                end


                // default is write character in teletype mode with auto-margin
                default:  begin
                    case (status)
                        NEW: begin
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
    endcase
end




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
            common_vram_addr <= {row, col};
            common_vram_din  <= char;
        end

    endcase
end


scroll scroll_m(
    .i_clk          (i_clk),
    .i_start        (scroll_start),     // assert high to start scrolling
    .o_running      (scroll_running),   // busy
    .o_vram_addr    (scroll_vram_addr),
    .o_vram_w       (scroll_vram_w),
    .o_vram_ce      (scroll_vram_ce),
    .i_vram_dout    (i_vram_dout),
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


endmodule
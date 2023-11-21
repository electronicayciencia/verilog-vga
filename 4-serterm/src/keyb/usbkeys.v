// Translate USB bytes to UART keys
module usbkeys (
    input            i_clk,
    // get a byte stream
    input      [7:0] i_byte,
    input            i_byte_valid,
    output reg       o_byte_ready = 1,
    // output keys
    input            i_key_ready,
    output reg       o_key_valid,
    output reg [7:0] o_key
);


wire [7:0] char;
reg  [7:0] mask = 0;

keymap keymap (
    .i_byte (i_byte), // input byte
    .i_mod  (mask),   // modifier
    .o_byte (char)    // output
);

// Detect key
// (57 AB 01) (00) (00) (2C)
// Magic, mask, reserved, key scan code
localparam LEN = 3; // len in bytes
localparam [LEN*8-1:0] magic = 24'h57AB01;

localparam 
    LOOK  = 2'd0, // looking for the magic sequence
    MASK  = 2'd1, // sequence found, the next byte is the mask
    RES   = 2'd2, // mask captured, next byte is reserved and must be 0
    CODE  = 2'd3; // next is the key scan code

reg [1:0] status = LOOK;
reg [3:0] idx   = 0;

wire [7:0] first = magic[8*(LEN-1) +: 8]; 
wire [7:0] next  = magic[8*(LEN-idx-1) +: 8];

always @(posedge i_clk) begin
    // next module ack'ed our newkey signal
    if (i_key_ready) begin
        o_key_valid  <= 0;
        o_byte_ready <= 1;  // ready for a new char
    end

    // we received a new byte
    if (i_byte_valid) begin
        case(status)

        LOOK: 
            begin
                // following the sequence
                if (i_byte == next)
                    if (idx == LEN - 1) begin
                        status <= MASK;
                        idx <= 0;
                    end
                    else
                        idx <= idx + 1'b1;
                // sequence start again inside a sequence
                else if (i_byte == first)
                    idx <= 1'b1;
                // out of sequence
                else
                    idx <= 0;
            end

        MASK:
            begin
                mask <= i_byte;
                status <= RES;
            end

        RES:
            status <= CODE;

        CODE:
            begin
                status <= LOOK;
                if (char) begin // do nothing for char = 0 (key release)
                    o_byte_ready <= 0; // halt data flow until our scan code is received
                    o_key_valid <= 1;
                    o_key <= char;  // <-- translate lookup table here
                end
            end
        endcase
    end
end

endmodule

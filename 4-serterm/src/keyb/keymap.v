/*
Map USB HID scan code to characters
1 key -> 1 character 
Escape character keys are not supported 
Spanish layout
If the key is not mapped, return the original USB HID scan code.
*/
module keymap (
    input      [7:0] i_byte, // input byte
    input      [7:0] i_mod,  // modifier
    output reg [7:0] o_byte  // output
);

localparam LCTRL  = 8'h01;
localparam LSHIFT = 8'h02;
localparam LALT   = 8'h04;
localparam LMETA  = 8'h08;
localparam RCTRL  = 8'h10;
localparam RSHIFT = 8'h20;
localparam RALT   = 8'h40;
localparam RMETA  = 8'h80;

wire ctrl  = |( (i_mod & LCTRL)  | (i_mod & RCTRL)  );
wire shift = |( (i_mod & LSHIFT) | (i_mod & RSHIFT) );
wire alt   = |( (i_mod & LALT)   | (i_mod & RALT)   );
wire meta  = |( (i_mod & LMETA)  | (i_mod & RMETA)  );


always @(i_byte, ctrl, shift, alt, meta) begin
    if (ctrl) begin
        case(i_byte)
            8'h00: o_byte <= 0;
            default: o_byte <= i_byte;
        endcase
    end
    else if (alt) begin
        case(i_byte)
            8'h00: o_byte <= 0;
            default: o_byte <= i_byte;
        endcase
    end
    else if (meta) begin
        case(i_byte)
            8'h00: o_byte <= 0;
            8'h1e: o_byte <= "|";  // Number 1
            8'h1f: o_byte <= "@";  // Number 2
            8'h20: o_byte <= "#";  // Number 3
            8'h21: o_byte <= "~";  // Number 4
            default: o_byte <= i_byte;
        endcase
    end
    else if (shift) begin
        case(i_byte)
            8'h00: o_byte <= 0;
            8'h04: o_byte <= "A";
            8'h05: o_byte <= "B";
            8'h06: o_byte <= "C";
            8'h07: o_byte <= "D";
            8'h08: o_byte <= "E";
            8'h09: o_byte <= "F";
            8'h0a: o_byte <= "G";
            8'h0b: o_byte <= "H";
            8'h0c: o_byte <= "I";
            8'h0d: o_byte <= "J";
            8'h0e: o_byte <= "K";
            8'h0f: o_byte <= "L";
            8'h10: o_byte <= "M";
            8'h11: o_byte <= "N";
            8'h12: o_byte <= "O";
            8'h13: o_byte <= "P";
            8'h14: o_byte <= "Q";
            8'h15: o_byte <= "R";
            8'h16: o_byte <= "S";
            8'h17: o_byte <= "T";
            8'h18: o_byte <= "U";
            8'h19: o_byte <= "V";
            8'h1a: o_byte <= "W";
            8'h1b: o_byte <= "X";
            8'h1c: o_byte <= "Y";
            8'h1d: o_byte <= "Z";

            8'h1e: o_byte <= "!";  // Number 1
            8'h1f: o_byte <= "\""; // Number 2
            //8'h20: o_byte <= "·";  // Number 3
            8'h21: o_byte <= "$";  // Number 4
            8'h22: o_byte <= "%";  // Number 5
            8'h23: o_byte <= "&";  // Number 6
            8'h24: o_byte <= "/";  // Number 7
            8'h25: o_byte <= "(";  // Number 8
            8'h26: o_byte <= ")";  // Number 9
            8'h27: o_byte <= "=";  // Number 0

            8'h2d: o_byte <= "_";
            8'h36: o_byte <= ";";
            8'h37: o_byte <= ":";

            default: o_byte <= i_byte;
        endcase
    end
    else begin
        case(i_byte)
            8'h00: o_byte <= 0;
            8'h04: o_byte <= "a";
            8'h05: o_byte <= "b";
            8'h06: o_byte <= "c";
            8'h07: o_byte <= "d";
            8'h08: o_byte <= "e";
            8'h09: o_byte <= "f";
            8'h0a: o_byte <= "g";
            8'h0b: o_byte <= "h";
            8'h0c: o_byte <= "i";
            8'h0d: o_byte <= "j";
            8'h0e: o_byte <= "k";
            8'h0f: o_byte <= "l";
            8'h10: o_byte <= "m";
            8'h11: o_byte <= "n";
            8'h12: o_byte <= "o";
            8'h13: o_byte <= "p";
            8'h14: o_byte <= "q";
            8'h15: o_byte <= "r";
            8'h16: o_byte <= "s";
            8'h17: o_byte <= "t";
            8'h18: o_byte <= "u";
            8'h19: o_byte <= "v";
            8'h1a: o_byte <= "w";
            8'h1b: o_byte <= "x";
            8'h1c: o_byte <= "y";
            8'h1d: o_byte <= "z";

            8'h1e: o_byte <= "1"; // Number 1
            8'h1f: o_byte <= "2"; // Number 2
            8'h20: o_byte <= "3"; // Number 3
            8'h21: o_byte <= "4"; // Number 4
            8'h22: o_byte <= "5"; // Number 5
            8'h23: o_byte <= "6"; // Number 6
            8'h24: o_byte <= "7"; // Number 7
            8'h25: o_byte <= "8"; // Number 8
            8'h26: o_byte <= "9"; // Number 9
            8'h27: o_byte <= "0"; // Number 0
 
            8'h28: o_byte <= 8'h0D; // Return (ENTER)
            8'h2a: o_byte <= 8'h08; // Backspace (not DEL)
            8'h2b: o_byte <= 8'h09; // Tab
            8'h2c: o_byte <= " ";   // Spacebar
            8'h2d: o_byte <= "-";
            8'h36: o_byte <= ",";
            8'h37: o_byte <= ".";

            default: o_byte <= i_byte;
        endcase
    end
end



endmodule
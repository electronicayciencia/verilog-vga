# Keyb

Modules to interact with an USB keyboard connected to CH9350L USB-to-UART chip.

Chip UART baud rate 115200/57600/38400.

State 2/3/4 keyboard data:
The 8-byte keyboard data is USB standard keyboard data, and the corresponding key values can be
parsed by referring to the "Full keyboard Code Value Table". For example:

57 AB 01 00 00 2C 00 00 00 00 00, indicates that the space key is pressed
57 AB 01 00 00 00 00 00 00 00 00, indicates that the space key is released
\------/  ^  ^  ^
    ^     |  |  +-- Keys 1-6
    |     |  +----- Reserved
    |     +-------- Mask
    +-------------- Keyboard data magic sequence 


Mask:

8421 8421
0000 0000
^^^^ ^^^^
|||| |||+- LCTRL
|||| ||+-- LSHIFT
|||| |+--- LALT
|||| +---- LMETA
|||+------ RCTRL
||+------- RSHIFT
|+-------- RALT
+--------- RMETA






# Text

This is the text engine. Imported from `3-text/mono_8x16`.

All of these modules use the derived 12MHz clock for the LCD.

They work with the port B (read) of the VRAM. 
Except `cursor` that monitors both ports A and B to draw the text cursor when they match.

The main module is `text.v`.

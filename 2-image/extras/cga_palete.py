#!/usr/bin/env python3

# Display CGA color palette available for Tang Nano board

# CGA standard palette:
#   0 black         #000000
#   1 blue          #0000AA
#   2 green         #00AA00
#   3 cyan          #00AAAA
#   4 red           #AA0000
#   5 magenta       #AA00AA
#   6 brown         #AA5500
#   7 light gray    #AAAAAA
#   8 dark gray     #555555
#   9 light blue    #5555FF
#  10 light green   #55FF55
#  11 light cyan    #55FFFF
#  12 light red     #FF5555
#  13 light magenta #FF55FF
#  14 yellow        #FFFF55
#  15 white         #FFFFFF



# Tang Nano CGA palette (RGB 565).
# 000000
# 0000af
# 00a800
# 00a8af
# af0000
# af00af
# afa800
# afa8af
# 505750
# 5057ff
# 50ff50
# 50ffff
# ff5750
# ff57ff
# ffff50
# ffffff

# GIMP Palette format
#---- start
# GIMP Palette
# Name: CGA 16 colors
# Columns: 8
# #
#   0   0   0	black
#   0   0 175	blue
#   0 168   0	green
#   0 168 175	cyan
# 175   0   0	red
# 175   0 175	magenta
# 175 168   0	brown
# 175 168 175	light gray
#  80  87  80	dark gray
#  80  87 255	light blue
#  80 255  80	light green
#  80 255 255	light cyan
# 255  87  80	light red
# 255  87 255	light magenta
# 255 255  80	yellow
# 255 255 255	white
#---- end


def mask_red(v):
    """ The 4 LSB are tied together """
    if (v & 0b1000):
        return v | 0b00001111
    else:
        return v & 0b11110000

def mask_green(v):
    """ The 3 LSB are tied together """
    if (v & 0b100):
        return v | 0b00000111
    else:
        return v & 0b11111000

def mask_blue(v):
    """ The 4 LSB are tied together """
    if (v & 0b1000):
        return v | 0b00001111
    else:
        return v & 0b11110000

color = [None] * 16
color[0]  = [ mask_red(0x00), mask_green(0x00), mask_blue(0x00) ]
color[1]  = [ mask_red(0x00), mask_green(0x00), mask_blue(0xaa) ]
color[2]  = [ mask_red(0x00), mask_green(0xaa), mask_blue(0x00) ]
color[3]  = [ mask_red(0x00), mask_green(0xaa), mask_blue(0xaa) ]
color[4]  = [ mask_red(0xaa), mask_green(0x00), mask_blue(0x00) ]
color[5]  = [ mask_red(0xaa), mask_green(0x00), mask_blue(0xaa) ]
color[6]  = [ mask_red(0xaa), mask_green(0xaa), mask_blue(0x00) ]
color[7]  = [ mask_red(0xaa), mask_green(0xaa), mask_blue(0xaa) ]

color[8]  = [ mask_red(0x55), mask_green(0x55), mask_blue(0x55) ]
color[9]  = [ mask_red(0x55), mask_green(0x55), mask_blue(0xff) ]
color[10] = [ mask_red(0x55), mask_green(0xff), mask_blue(0x55) ]
color[11] = [ mask_red(0x55), mask_green(0xff), mask_blue(0xff) ]
color[12] = [ mask_red(0xff), mask_green(0x55), mask_blue(0x55) ]
color[13] = [ mask_red(0xff), mask_green(0x55), mask_blue(0xff) ]
color[14] = [ mask_red(0xff), mask_green(0xff), mask_blue(0x55) ]
color[15] = [ mask_red(0xff), mask_green(0xff), mask_blue(0xff) ]


for i in color:
    print("%02x%02x%02x" % (i[0], i[1], i[2]))




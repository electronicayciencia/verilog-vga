#!/usr/bin/env python

# Translate 16 bit color image to Gowin Memory Initialization file.


import sys
from PIL import Image
from math import log2, ceil


def usage():
    print("Translate 16 bit color image to Gowin Memory Initialization file")
    print("Usage: {} image_file > file.im".format(sys.argv[0]))
    exit(1)

def miheader(depth, width):
    """ Return MI header """
    miheader = "#File_format=Hex\n" \
             + "#Address_depth={}\n".format(depth) \
             + "#Data_width={}".format(width)

    return miheader


def depth(im):
    """Return depth and check number of address lines"""
    (h,v) = im.size
    addrh = ceil(log2(h-1))
    addrv = ceil(log2(v-1))

    if (addrh+addrv > 15):
        print("Error: not enough memory address lines ({}).".format(addrh+addrv))
        exit(1)
    
    return 2**(addrh+addrv)
    
def convert_16bit(im):
    """ Read image. """

    print(miheader(depth(im), 16))  # data width = 16
    
    px = im.load()
    for lin in range(im.size[1]):
        for col in range(im.size[0]):
            (r8, g8, b8) = px[col, lin]
            r5 = r8 >> 3
            g6 = g8 >> 2
            b5 = b8 >> 3
            rgb565 = r5
            rgb565 = (rgb565 << 6) + g6
            rgb565 = (rgb565 << 5) + b5
            print("%04x" % (rgb565))
    

def main():
    if len(sys.argv) <= 1:
        usage()

    im = Image.open(sys.argv[1])
    convert_16bit(im)



main()
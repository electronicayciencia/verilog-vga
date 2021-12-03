#!/usr/bin/env python

# Translate 4 color image to Gowin Memory Initialization file

import sys
from PIL import Image
from math import log2, ceil


def usage():
    print("Translate monochromatic image to Gowin Memory Initialization file")
    print("Usage: {} image_file > file.im".format(sys.argv[0]))
    exit(1)

def miheader(depth, width):
    """ Return MI header """
    miheader = "#File_format=AddrHex\n" \
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
    
    return 2**(addrh+addrv)-1
    
def convert_mono(im):
    """ Read image. FIX: Assume 7bit address for cols and lines. """

    print(miheader(depth(im), 2))  # data width = 2
    
    px = im.load()
    for lin in range(im.size[1]):
        for col in range(im.size[0]):
            if px[col, lin] > 0:
                print("%02x%02x:%d" % (lin, col, px[col, lin]))
    

def main():
    if len(sys.argv) <= 1:
        usage()

    im = Image.open(sys.argv[1])
    convert_mono(im)



main()
#/usr/bin/env python

# Convert BMP image file to Gowin Memory Initialization file

import sys
from PIL import Image
from math import log2, ceil


def usage():
    print("Usage: {} bmpfile > imfile".format(sys.argv[0]))
    exit(1)


def convert_indexed(im):
    """ Read indexed image """
    depth = im.size[0] * im.size[1]
    miheader = "#File_format=Hex\n" \
             + "#Address_depth={}\n".format(depth) \
             + "#Data_width={}".format(ceil(log2(len(im.palette.colors))))

    print(miheader)
    
    px = im.load()
    for lin in range(im.size[1]):
        for col in range(im.size[0]):
            print(px[col, lin])
    

def convert_rgb(im):
    """ Read RGB image and print like 16 bit format """
    pass


if len(sys.argv) <= 1:
    usage()

im = Image.open(sys.argv[1])



# Check image properties
if im.mode == 'RGB':
    convert_rgb(im)
elif im.mode == 'P':
    convert_indexed(im)
else:
    print("Incompatible image format. Must be 16/24 bits RGB or indexed.")
    exit(2)

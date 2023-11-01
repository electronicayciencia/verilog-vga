#!/usr/bin/env python

# Translate binary screen files to Gowin Memory Initialization file

import os
import sys
from math import log2, ceil

def usage():
    print("Usage: {} screen.bin ncols nlines > file.im".format(sys.argv[0]))
    exit(1)


def miheader(depth, width):
    """ Return MI header """
    miheader = "#File_format=Hex\n" \
             + "#Address_depth={}\n".format(depth) \
             + "#Data_width={}".format(width)

    return miheader


def main():
    print("Translate binary screen files to Gowin Memory Initialization file", file=sys.stderr)

    if len(sys.argv) <= 3:
        usage()

    filename = sys.argv[1]
    ncols    = int(sys.argv[2])
    nlines   = int(sys.argv[3])

    buffer_x = 2**ceil(log2(ncols))
    buffer_y = 2**ceil(log2(nlines))

    buffer_depth = buffer_x * buffer_y

    file_len = os.stat(filename).st_size
    
    # 8: mono, 16: color
    data_width = ceil(file_len / (ncols*nlines) * 8)
    
    if (data_width not in [16]):
        print("Data width ({}) not supported or inconsistent file dimensions.".format(data_width), file=sys.stderr)
        exit(1)

    print("Viewport size: {} x {}".format(ncols, nlines), file=sys.stderr)
    print("Buffer size:   {} x {}  (depth: {})".format(buffer_x, buffer_y, buffer_depth), file=sys.stderr)
    print("Data width:    {}".format(data_width), file=sys.stderr)

    print(miheader(buffer_depth, data_width))

    with open(filename, 'rb') as f:
        for y in range(0, buffer_y):
            for x in range(0, buffer_x):
                if x < ncols and y < nlines:
                    f.seek(x + ncols*y)
                    character = ord(f.read(1))
                    
                    f.seek(x + ncols*y + ncols*nlines)
                    attribute = ord(f.read(1))
                else:
                    character = 0
                    attribute = 0
                    
                print("{:02x}{:02x}".format(attribute, character))
                    


main()
#!/usr/bin/env python
# Create a Memory Initialization File for Character Buffer mono from a text file.

import sys
from math import log2, ceil, pow

def readtext(filename):
    """Load the text file into an array of lines."""
    with open(filename) as f:
        mylist = f.read().splitlines()

    return mylist


def print_mi_header(file_format, address_depth, data_width):
    """Print MI file header via STDOUT."""

    print("#File_format={}".format(file_format))
    print("#Address_depth={}".format(address_depth))
    print("#Data_width={}".format(data_width))


def fill(h_pixels, v_pixels, text_size_x_px, text_size_y_px, filename, filling_char):
    # Assume full 256 ascii
    available_chars = 256

    # Calculate visible frame
    visible_cols  = h_pixels / text_size_x_px
    visible_lines = v_pixels / text_size_y_px

    # Calculate next power of two of that
    buffer_cols  = ceil(pow(2, ceil(log2(visible_cols))))
    buffer_lines = ceil(pow(2, ceil(log2(visible_lines))))

    address_depth = buffer_cols * buffer_lines
    data_width = ceil(log2(available_chars))

    text = readtext(filename)

    print_mi_header("Hex", address_depth, data_width)

    for line in range(0, buffer_lines):
        for col in range(0, buffer_cols):
            if len(text) > line and len(text[line]) > col:
                n = ord(text[line][col])
                if n >= 256:
                    raise(ValueError(
                        "Non valid character detected in line {} col {}: {} > {}".format(line+1, col+1, n, available_chars)))
                print("{:02x}".format(n))

            else:
                print("{:02x}".format(ord(filling_char)))


def main():
    if len(sys.argv) < 2:
        print("Usage: {} filename.txt [charsizeX] [charsizeY]".format(sys.argv[0]))
        exit(1)
    else:
        filename = sys.argv[1]

    if len(sys.argv) >= 3:
        text_size_x_px = int(sys.argv[2])
    else:
        text_size_x_px = 8

    if len(sys.argv) >= 4:
        text_size_y_px = int(sys.argv[3])
    else:
        text_size_y_px = 8


    # Screen dimensions
    h_pixels = 480
    v_pixels = 272

    filling_char = ' ' # What to print in invisible zones

    fill(h_pixels, v_pixels, text_size_x_px, text_size_y_px, filename, filling_char)


main()

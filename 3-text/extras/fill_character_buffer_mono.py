#!/usr/bin/env python
# Create a Memory Initialization File for Character Buffer 64x64 mono.

from math import log2, ceil, pow

# Screen dimensions
h_pixels = 480
v_pixels = 272

# Text cell size
text_size_px = 8

# What to print in invisible zones
filling_char = '0'

available_chars = 256

# Calculate visible frame
visible_cols  = h_pixels / text_size_px
visible_lines = v_pixels / text_size_px

# Calculate next power of two
buffer_cols  = ceil(pow(2, ceil(log2(visible_cols))))
buffer_lines = ceil(pow(2, ceil(log2(visible_lines))))

address_depth = buffer_cols * buffer_lines
data_width = ceil(log2(available_chars))

print("#File_format=Hex")
print("#Address_depth={}".format(address_depth))
print("#Data_width={}".format(data_width))

counter = 0

for line in range(0, buffer_lines):
    for col in range(0, buffer_cols):
        if line < visible_lines and col < visible_cols:
            print("{:02x}".format(counter))
            counter = counter + 1
            
            if counter >= available_chars:
                counter = 0
                
        else:
            print("{:02x}".format(ord(filling_char)))

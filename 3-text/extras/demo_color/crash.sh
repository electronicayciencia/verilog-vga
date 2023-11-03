#!/bin/bash
 
# Dump binary to 64x32x(8+8) memory initialization file

echo "#File_format=Hex"
echo "#Address_depth=2048"
echo "#Data_width=16"

xxd -s 2048 -ps /bin/ls | fold -b4 | uniq | head -n 2048



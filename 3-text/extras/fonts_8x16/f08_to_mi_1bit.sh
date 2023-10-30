#!/bin/bash
# Convert .f08 from http://orangetide.com/fonts/DOS/
# to Gowin Memory initialization file
#
# Global usage:
# for i in *.f08; do echo "./f082mi.sh $i > $(basename $i .f08).mi"; done

maxchars=256
maxlines=$((maxchars*8*16))

if [ -z $1 ]
then
	echo "Usage: $0 cp437.f16 > cp437.mi"
	exit 1
fi

cat << header
#File_format=Bin
#Address_depth=$maxlines
#Data_width=1
header

xxd -b -c 1 $1 | cut -d' ' -f 2 | fold -w 1 | head -n $((maxlines))

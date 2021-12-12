#!/bin/bash
# Convert .f08 from
# http://orangetide.com/fonts/DOS/
# to Gowin Memory initialization file
#
# Global usage:
# for i in *.f08; do echo "./f082mi.sh $i > $(basename $i .f08).mi"; done

maxchars=256
maxlines=$((maxchars*8))

if [ -z $1 ]
then
	echo "Usage: $0 cp437.f08 > cp437.mi"
	exit 1
fi

cat << header
#File_format=Hex
#Address_depth=$maxlines
#Data_width=8
header

od -tx1 -v $1 | cut -s -d ' ' -f 2- | tr ' ' '\n' | head -n $((maxlines-8))

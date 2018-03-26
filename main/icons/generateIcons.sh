#!/bin/sh
SIZES="86 108 128"

# $1 path
# $2 size
exportImage() {
	inkscape --export-png="$1" --export-area-page --export-width="$2" --export-height="$2" icon.svg
}

for size in $SIZES
do
	exportImage "$size"x"$size"/harbour-battery-charging-control.png "$size"
done

# background image for our cover
exportImage ../images/background.png 860
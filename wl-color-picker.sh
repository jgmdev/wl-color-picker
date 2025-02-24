#!/bin/bash
#
# License: MIT
#
# A script to easily pick a color on a wayland session by using:
# slurp to select the location, grim to get the pixel, convert
# to make the pixel a hex number and zenity to display a nice color
# selector dialog where the picked color can be tweaked further.
#
# The script was possible thanks to the useful information on:
# https://www.trst.co/simple-colour-picker-in-sway-wayland.html
# https://unix.stackexchange.com/questions/320070/is-there-a-colour-picker-that-works-with-wayland-or-xwayland/523805#523805
#

showhelp() {
    echo "A basic wlroots compatible color picker script."
    echo ""
    echo "Usage:"
    echo "  wl-color-picker [command] [options]"
    echo ""
    echo "Commands:"
    echo "  clipboard       Copy color to clipboard without dialog"
    echo "    --no-notify   Don't show a system notification of copied color"
}

CLIPBOARD=0
NO_NOTIFY=0

while [ "$1" ]; do
    case $1 in
        '-h' | '--help' | 'help' | '?' )
            showhelp
            exit
            ;;
        'clipboard' )
            CLIPBOARD=1
            ;;
        '--no-notify' )
            NO_NOTIFY=1
            ;;
    esac

    shift
done

# Check if running under wayland.
if [ "$WAYLAND_DISPLAY" = "" ]; then
    zenity  --error --width 400 \
        --title "No wayland session found." \
        --text "This color picker must be run under a valid wayland session."

    exit 1
fi

# Get color position
position=$(slurp -b 00000000 -p)

# Sleep at least for a second to prevet issues with grim always
# returning improper color.
sleep 1

# Store the hex color value using graphicsmagick or imagemagick.
if command -v /usr/bin/gm &> /dev/null; then
    color=$(grim -g "$position" -t png - \
        | /usr/bin/gm convert - -format '%[pixel:p{0,0}]' txt:- \
        | tail -n 1 \
        | rev \
        | cut -d ' ' -f 1 \
        | rev
    )
else
    color=$(grim -g "$position" -t png - \
        | convert - -format '%[pixel:p{0,0}]' txt:- \
        | tail -n 1 \
        | cut -d ' ' -f 4
    )
fi

if [ $CLIPBOARD -eq 1 ]; then
    echo $color | wl-copy -n
    if [ $NO_NOTIFY -ne 1 ]; then
        notify-send "Color copied to clipboard." $color
    fi
else
    # Display a color picker and store the returned rgb color
    rgb_color=$(zenity --color-selection \
        --title="Copy color to Clipboard" \
        --color="${color}"
    )

    # Execute if user didn't click cancel
    if [ "$rgb_color" != "" ]; then
        # Convert rgb color to hex
        hex_color="#"
        for value in $(echo "${rgb_color}" | grep -E -o -m1 '[0-9]+'); do
           hex_color="$hex_color$(printf "%.2x" $value)"
        done

        # Copy user selection to clipboard
        echo $hex_color | wl-copy -n
    fi
fi

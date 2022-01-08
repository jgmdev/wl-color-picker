# wl-color-picker

A script that provides a working color picker for wayland and wlroots
by leveraging [grim](https://github.com/emersion/grim) and
[slurp](https://github.com/emersion/slurp).

## Usage
  - Command `wl-color-picker` - Select position on screen and open color picker window
  - Command `wl-color-picker clipboard` - Select position on screen without opening color picker window, just copy selected color to clipboard


## Inspiration

This script is possible by the information provided on the following
sites:

* https://www.trst.co/simple-colour-picker-in-sway-wayland.html
* https://unix.stackexchange.com/questions/320070/is-there-a-colour-picker-that-works-with-wayland-or-xwayland/523805#523805

## Artwork

The icon was taken from the gcolor3 icon shipped with the
[papirus icon theme](https://github.com/PapirusDevelopmentTeam/papirus-icon-theme),
so all credits go to the papirus icon designers.

## Dependencies

* __slurp__ - provides the screen location picker
* __grim__ - uses the location provided by slurp and generates a pixel
* __convert__ - uitlity from imagemagick to make the pixel a hex number (graphicsmagick is also supported)
* __zenity__ - display a nice color selector dialog where the picked color can be tweaked further
* __wl-copy__ - copy the selected color to the clipboard

## Packages

ArchLinux - install from [AUR](https://aur.archlinux.org/packages/wl-color-picker)
```sh
yay -S wl-color-picker
```

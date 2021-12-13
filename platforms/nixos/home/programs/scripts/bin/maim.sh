#!/usr/bin/env bash

FILE="$HOME/screen.png"

while getopts "s" opt; do
    case "$opt" in
        s) SELECT=1 ;;
        *) ;;
    esac
done

case "$XDG_SESSION_TYPE" in
    x11) dmenu="rofi -dmenu" ;;
    wayland) dmenu="wofi --dmenu" ;;
    *) ;;
esac
options=("Default" "Imgur")
choice=$(printf "%s\n" "${options[@]}" | eval "$dmenu")
[ $? = 0 ] || exit 1

if [ "$SELECT" ]; then
    case "$XDG_SESSION_TYPE" in
        x11) maim --select "$FILE" --hidecursor ;;
        wayland) grim -g "$(slurp)" "$FILE" ;;
        *) ;;
    esac
else
    case "$XDG_SESSION_TYPE" in
        x11) maim --capturebackground "$FILE" --hidecursor ;;
        wayland) grim "$FILE" ;;
        *) ;;
    esac
fi

case $choice in
    "Default")
        case "$XDG_SESSION_TYPE" in
            x11) xclip -selection clipboard -target image/png < "$FILE" ;;
            wayland) wl-copy --type image/png < "$FILE" ;;
            *) ;;
        esac
        notify-send "maim.sh" "Screenshot was saved to $FILE"
        ;;
    "Imgur")
        "$HOME/.local/platform/bin/imgur" "$FILE"
        notify-send "maim.sh" "Screenshot was uploaded to imgur"
        ;;
esac

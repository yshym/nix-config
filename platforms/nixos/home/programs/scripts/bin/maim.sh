#!/usr/bin/env bash

FILE="$HOME/screen.png"

while getopts "s" opt; do
    case "$opt" in
        s)
            SELECT=true
    esac
done

options=("Default" "Imgur")
choice=$(printf "%s\n" "${options[@]}" | rofi -dmenu);
[ $? = 0 ] || exit

if [ "$SELECT" == true ]; then
    case "$XDG_SESSION_TYPE" in
        x11)
            maim --select "$FILE" --hidecursor;;
        wayland)
            grim -g "$(slurp)" "$FILE"
    esac
else
    case "$XDG_SESSION_TYPE" in
        x11)
            maim --capturebackground "$FILE" --hidecursor;;
        wayland)
            grim "$FILE"
    esac
fi

case $choice in
    "Default")
        case "$XDG_SESSION_TYPE" in
            x11)
                cat "$FILE" | xclip -selection clipboard -target image/png;;
            wayland)
                cat "$FILE" | wl-copy --type image/png
        esac
        notify-send "Screenshot was saved to" "$FILE"
        ;;
    "Imgur")
        notify-send "Uploading to imgur..."
        IMGUR_LINK=$(imgur "$FILE" | head -n 1)
        notify-send "Uploaded"
        case "$XDG_SESSION_TYPE" in
            x11)
                echo "$IMGUR_LINK" | xclip -selection clipboard;;
            wayland)
                echo "$IMGUR_LINK" | wl-copy
        esac
esac

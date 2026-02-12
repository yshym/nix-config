#!/usr/bin/env bash

source "$HOME/.config/yabai/padding/padding.env"

spece_id="$YABAI_SPACE_ID"
if [ -z "$YABAI_SPACE_ID" ]; then
    space_id=$1
fi
number_of_windows=$(yabai -m query --windows --space $space_id | jq "length")
if [ -z $space_id ]; then
    space_type=$(yabai -m query --spaces | jq -r '.[] | select(."has-focus"==true) | .type')
else
    space_type=$(yabai -m query --spaces | jq -r ".[$space_id]")
fi
padding=$(([ "$number_of_windows" -eq 1 ] || [ "$space_type" = "stack" ]) && echo 0 || echo "$PADDING")

hpadding="$padding"
if [ "$("$HOME/.config/yabai/padding/ultrawide/is-connected.sh")" = "true" ]; then
    hpadding="$ULTRAWIDE_PADDING"
fi

yabai -m space --padding "abs:$padding:$padding:$hpadding:$hpadding" &

if [ "$padding" -eq 0 ]; then
    "$BORDERS" width=0 &
else
    "$BORDERS" width="$BORDER_WIDTH" &
fi

echo "padding: $padding, hpadding: $hpadding" >> "$HOME/yabailogs.txt"

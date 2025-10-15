#!/usr/bin/env sh

space_id=$1
space_info=$(yabai -m query --windows --space $space_id | jq)
number_of_windows=$(yabai -m query --windows --space $space_id | jq "length")
if [ -z $space_id ]; then
    space_type=$(yabai -m query --spaces | jq -r '.[] | select(."has-focus"==true) | .type')
else
    space_type=$(yabai -m query --spaces | jq -r ".[$space_id]")
fi
padding=$(([ "$number_of_windows" -eq 1 ] || [ "$space_type" = "stack" ]) && echo 0 || echo 10)

echo "space_info: $space_info, padding: $padding, number_of_windows: $number_of_windows" >> "$HOME/yabailogs.txt"

yabai -m config --space mouse top_padding "$padding"
yabai -m config --space mouse bottom_padding "$padding"
if [ "$("$HOME/.config/yabai/padding/ultrawide/is-connected.sh")" = "false" ]; then
    yabai -m config --space mouse left_padding "$padding"
    yabai -m config --space mouse right_padding "$padding"
fi

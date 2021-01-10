#!/usr/bin/env bash

space_info=$(yabai -m query --windows --space | jq)
number_of_windows=$(yabai -m query --windows --space | jq "length")
padding=$([ "$number_of_windows" -eq 1 ] && echo 0 || echo 10)

echo "space_info: $space_info, padding: $padding, number_of_windows: $number_of_windows" >> "$HOME/yabailogs.txt"

yabai -m config --space mouse top_padding "$padding"
yabai -m config --space mouse bottom_padding "$padding"
yabai -m config --space mouse left_padding "$padding"
yabai -m config --space mouse right_padding "$padding"

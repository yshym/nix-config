#!/usr/bin/env sh

number_of_spaces=$(yabai -m query --spaces | jq "length")

si=1
while (( si < $number_of_spaces )); do
    "$HOME/.config/yabai/padding/adaptive/refresh.sh" $si

    si=$((si+1))
done

"$HOME/.config/yabai/padding/adaptive/signals.sh"

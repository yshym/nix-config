#!/usr/bin/env bash

#
# Change padding depending on whether an ultrawide display is connected
#

source "$HOME/.config/yabai/padding/padding.env"

DISPLAYS=$(yabai -m query --displays)
HAS_INTERNAL=$(echo "$DISPLAYS" | jq -r "[.[].uuid] | any(. == \"$INTERNAL_DISPLAY_UUID\")")
HAS_ULTRAWIDE=$(echo "$DISPLAYS" | jq -r "[.[].uuid] | any(. == \"$ULTRAWIDE_DISPLAY_UUID\")")

if [ "$HAS_INTERNAL" = "true" ]; then
    echo "Internal display connected"
    "$SET_HORIZONTAL_PADDING" "$PADDING"
elif [ "$HAS_ULTRAWIDE" = "true" ]; then
    echo "Ultrawide display connected without internal"
    "$SET_HORIZONTAL_PADDING" "$ULTRAWIDE_PADDING"
else
    echo "No known display detected"
    "$SET_HORIZONTAL_PADDING" "$PADDING"
fi

yabai -m signal --add event=display_added   action="$HOME/.config/yabai/padding/ultrawide/on_display_added"
yabai -m signal --add event=display_removed action="$HOME/.config/yabai/padding/ultrawide/on_display_removed"

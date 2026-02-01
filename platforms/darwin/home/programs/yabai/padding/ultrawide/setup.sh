#!/usr/bin/env bash

#
# Change padding depending on whether an ultrawide display is connected
#

source "$HOME/.config/yabai/padding/padding.env"

DISPLAY_UUID=$(yabai -m query --displays | jq -r ".[0].uuid")

if [ "$DISPLAY_UUID" = "$ULTRAWIDE_DISPLAY_UUID" ]; then
    echo "Ultrawide display detected"
    "$SET_VERTICAL_PADDING" "$ULTRAWIDE_PADDING"
else
    echo "No ultrawide display detected"
    "$SET_VERTICAL_PADDING" "$PADDING"
fi

yabai -m signal --add event=display_added   action="$HOME/.config/yabai/padding/ultrawide/on_display_added"
yabai -m signal --add event=display_removed action="$HOME/.config/yabai/padding/ultrawide/on_display_removed"

#!/usr/bin/env bash

source "$HOME/.config/yabai/padding/padding.env"

DISPLAY_UUID=$(yabai -m query --displays | jq -r ".[0].uuid")

if [ "$DISPLAY_UUID" = "$ULTRAWIDE_DISPLAY_UUID" ]; then
    echo "true"
else
    echo "false"
fi

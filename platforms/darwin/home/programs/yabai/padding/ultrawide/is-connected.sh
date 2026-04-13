#!/usr/bin/env bash

source "$HOME/.config/yabai/padding/padding.env"

DISPLAYS=$(yabai -m query --displays)
HAS_ULTRAWIDE=$(echo "$DISPLAYS" | jq -r "[.[].uuid] | any(. == \"$ULTRAWIDE_DISPLAY_UUID\")")

echo "$HAS_ULTRAWIDE"

#!/usr/bin/env bash

ULTRAWIDE_DISPLAY_UUID="26F43807-614D-4297-BFF2-B35B1D7A6547";

ULTRAWIDE_DISPLAY_ID=$(yabai -m query --displays | jq --arg ULTRAWIDE_DISPLAY_UUID "$ULTRAWIDE_DISPLAY_UUID" '.[] | select(.uuid == $ULTRAWIDE_DISPLAY_UUID) .id')
DISPLAY_ID=$(yabai -m query --displays | jq ".[0].id")

if [ "$DISPLAY_ID" = "$ULTRAWIDE_DISPLAY_ID" ]; then
    echo "true"
else
    echo "false"
fi

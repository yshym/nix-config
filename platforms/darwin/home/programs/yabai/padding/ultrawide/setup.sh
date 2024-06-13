#!/usr/bin/env bash

#
# Change padding depending on whether an ultrawide display is connected
#

PADDING=10
ULTRAWIDE_PADDING=500
ULTRAWIDE_DISPLAY_UUID="26F43807-614D-4297-BFF2-B35B1D7A6547";

ULTRAWIDE_DISPLAY_ID=$(yabai -m query --displays | jq --arg ULTRAWIDE_DISPLAY_UUID "$ULTRAWIDE_DISPLAY_UUID" '.[] | select(.uuid == $ULTRAWIDE_DISPLAY_UUID) .id')
DISPLAY_ID=$(yabai -m query --displays | jq ".[0].id")

if [ "$DISPLAY_ID" = "$ULTRAWIDE_DISPLAY_ID" ]; then
    echo "Ultrawide display detected. Setting padding to $ULTRAWIDE_PADDING"
    yabai -m config left_padding "$ULTRAWIDE_PADDING" \
        && yabai -m config right_padding "$ULTRAWIDE_PADDING"
else
    echo "No ultrawide display detected. Setting padding to $PADDING"
    yabai -m config left_padding "$PADDING" \
        && yabai -m config right_padding "$PADDING"
fi

yabai -m signal --add event=display_added action='[ "$YABAI_DISPLAY_ID" = "$ULTRAWIDE_DISPLAY_ID" ] \
    && yabai -m config left_padding "$ULTRAWIDE_PADDING" \
    && yabai -m config right_padding "$ULTRAWIDE_PADDING'
yabai -m signal --add event=display_removed action='[ "$YABAI_DISPLAY_ID" = "$ULTRAWIDE_DISPLAY_ID" ] \
    && yabai -m config left_padding "$PADDING" \
    && yabai -m config right_padding "$PADDDING"'

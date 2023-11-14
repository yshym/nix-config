#!/usr/bin/env sh

#
# Change padding depending on whether an ultrawide display is connected
#

ULTRAWIDE_PADDING=500
ULTRAWIDE_DISPLAY_UUID="26F43807-614D-4297-BFF2-B35B1D7A6547";

ULTRAWIDE_DISPLAY_ID=$(yabai -m query --displays | jq -e '.[] | select(.uuid == "$ULTRAWIDE_DISPLAY_UUID") .id')
DISPLAY_ID=$(yabai -m query --displays | jq -e ".[0].id")

[ $DISPLAY_ID -eq 5 ] \
    && yabai -m config left_padding $ULTRAWIDE_PADDING \
    && yabai -m config right_padding $ULTRAWIDE_PADDING

yabai -m signal --add event=display_added action="[ $YABAI_DISPLAY_ID -eq $ULTRAWIDE_DISPLAY_ID ] \
    && yabai -m config left_padding $ULTRAWIDE_PADDING \
    && yabai -m config right_padding $ULTRAWIDE_PADDING"
yabai -m signal --add event=display_removed action="[ $YABAI_DISPLAY_ID -eq $ULTRAWIDE_DISPLAY_ID ] \
    && yabai -m config left_padding $ULTRAWIDE_PADDING \
    && yabai -m config right_padding $ULTRAWIDE_PADDDING"
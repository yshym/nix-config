#!/usr/bin/env bash

SPACE="$(yabai -m query --spaces | jq -r '.[] | select(."has-focus" == true)')"
SPACE_INDEX="$(echo "$SPACE" | jq -r ".index")"
SPACE_TYPE="$(echo "$SPACE" | jq -r ".type")"

[ "$SPACE_TYPE" = "stack" ] \
    && yabai -m config --space "$SPACE_INDEX" layout bsp \
    || yabai -m config --space "$SPACE_INDEX" layout stack

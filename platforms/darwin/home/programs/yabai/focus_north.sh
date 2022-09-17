#!/usr/bin/env bash

[ "$(yabai -m query --spaces --space mouse | jq -r .type)" = "stack" ] \
    && (yabai -m window --focus stack.prev \
        || yabai -m window --focus stack.last) \
    || yabai -m window --focus north

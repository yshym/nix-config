#!/usr/bin/env bash

[ "$(yabai -m query --spaces --space mouse | jq -r .type)" = "stack" ] \
    && (yabai -m window --focus stack.next \
        || yabai -m window --focus stack.first) \
    || yabai -m window --focus south

#!/usr/bin/env bash

[ "$(yabai -m query --spaces \
    | jq -r '.[] | select(."has-focus" == true).type')" = "stack" ] \
    && (yabai -m window --focus stack.next \
        || yabai -m window --focus stack.first) \
    || yabai -m window --focus south

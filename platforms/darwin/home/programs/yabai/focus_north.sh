#!/usr/bin/env bash

[ "$(yabai -m query --spaces \
    | jq -r '.[] | select(."has-focus" == true).type')" = "stack" ] \
    && (yabai -m window --focus stack.prev \
        || yabai -m window --focus stack.last) \
    || yabai -m window --focus north

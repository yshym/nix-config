#!/usr/bin/env bash

[ "$(yabai -m query --spaces --space mouse | jq .type)" = "\"stack\"" ] \
    && yabai -m config --space mouse layout bsp \
    || yabai -m config --space mouse layout stack

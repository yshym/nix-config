#!/usr/bin/env bash

yabai -m window --focus east \
    || yabai -m window --focus "$( \
        (yabai -m query --spaces --display next || yabai -m query --spaces --display first) \
            | jq -re '.[] | select(.visible == 1)."first-window"')" \
    || yabai -m display --focus next \
    || yabai -m display --focus first

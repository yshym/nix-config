#!/usr/bin/env bash

yabai -m window --focus west \
    || yabai -m window --focus "$( \
        (yabai -m query --spaces --display prev || yabai -m query --spaces --display last) \
            | jq -re '.[] | select(."is-visible" == true)."last-window"')" \
    || yabai -m display --focus prev \
    || yabai -m display --focus last

#!/usr/bin/env bash

# Focus the first window on the target space (this also switches the space
# as a side effect), then explicitly focus the space to update yabai state.
# Doing window-focus first avoids jankyborders flicker that occurs when
# `space --focus` briefly drops window focus.
wid=$(yabai -m query --spaces --space "$1" | jq -r '.windows[0] // empty')
[[ -n "$wid" ]] && yabai -m window --focus "$wid"
yabai -m space --focus "$1"

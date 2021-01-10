#!/usr/bin/env bash

yabai -m config top_padding 10
yabai -m config bottom_padding 10
yabai -m config left_padding 10
yabai -m config right_padding 10

# window_numbers=$(yabai -m query --spaces \
#     | jq ".[].index"  \
#     | xargs -I{} yabai -m query --windows --space {} \
#     | jq "length")

# di=1
# for wn in $window_numbers; do
#     p=$((wn == 1 ? 0 : 10))

#     yabai -m config --space $di top_padding $p
#     yabai -m config --space $di bottom_padding $p
#     yabai -m config --space $di left_padding $p
#     yabai -m config --space $di right_padding $p

#     di=$((di+1))
# done

# "$HOME/.config/yabai/padding/signals.sh"

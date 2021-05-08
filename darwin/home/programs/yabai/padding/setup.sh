#!/usr/bin/env sh

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

"$HOME/.config/yabai/padding/signals.sh"

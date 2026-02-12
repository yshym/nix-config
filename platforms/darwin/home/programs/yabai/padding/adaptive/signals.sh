#!/usr/bin/env bash

refresh_padding_script_path="$HOME/.config/yabai/padding/adaptive/refresh.sh"

yabai -m signal --add event=window_created action="$refresh_padding_script_path"
yabai -m signal --add event=window_destroyed action="$refresh_padding_script_path"
# Track space type changes like bsp -> stack
yabai -m signal --add event=window_resized action="$refresh_padding_script_path"
yabai -m signal --add event=application_launched action="$refresh_padding_script_path"
yabai -m signal --add event=application_terminated action="$refresh_padding_script_path"
# TODO Make it more efficient. Show or hide borders only when this signal is received
yabai -m signal --add event=space_changed action="$refresh_padding_script_path"

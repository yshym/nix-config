#!/usr/bin/env bash

refresh_padding_script_path="$HOME/.config/yabai/padding/refresh.sh"

yabai -m signal --add event=window_created action="$refresh_padding_script_path"
yabai -m signal --add event=window_destroyed action="$refresh_padding_script_path"
# yabai -m signal --add event=application_launched action="$refresh_padding_script_path"
# yabai -m signal --add event=application_terminated action="$refresh_padding_script_path"

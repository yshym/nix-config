#!/usr/bin/env bash

session="$(tmux list-sessions -F '#{session_name}' | fzf-tmux -p 80%,70% \
    --no-sort --ansi --border-label 'session' \
    --preview-window 'right:55%' \
    --preview 'tmux capture-pane -pt {}')"
tmux switch -t "$session"

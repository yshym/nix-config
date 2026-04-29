#!/usr/bin/env bash

session="$(tmux list-sessions -F '#{session_name}' | fzf-tmux -p 50%,50% \
    --no-sort --ansi --border-label 'session' \
    --preview-window 'right:50%' \
    --preview 'tmux capture-pane -pt {}')"
tmux switch -t "$session"

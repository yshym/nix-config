#!/usr/bin/env sh

# check nix-related paths
[ "$(which nix &> /dev/null)" -ne 0 ] && \
    export PATH="$HOME/.nix-profile/bin:$PATH" && \
    export PATH="/nix/var/nix/profiles/default/bin:$PATH" && \
    export PATH="/run/current-system/sw/bin:$PATH"

# check brew-related paths
[ "$(which brew &> /dev/null)" -ne 0 ] && export PATH="/usr/local/bin:$PATH"

# check system-related paths
[ "$(which reboot &> /dev/null)" -ne 0 ] && export PATH="/sbin:$PATH"

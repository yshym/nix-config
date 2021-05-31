#!/usr/bin/env sh

if (! command -v darwin-rebuild); then
    echo "Installing nix-darwin..."

    echo "run\tprivate/var/run" | sudo tee -a /etc/synthetic.conf
    /System/Library/Filesystems/apfs.fs/Contents/Resources/apfs.util -B

    export NIX_PATH="darwin-config=/Users/runner/work/nix-config/nix-config/configuration.nix:/nix/var/nix/profiles/per-user/root/channels:/Users/runner/.nix-defexpr/channels"

    $(nix-build '<darwin>' -A system --no-out-link)/sw/bin/darwin-rebuild build
    $(nix-build '<darwin>' -A system --no-out-link)/sw/bin/darwin-rebuild switch
fi

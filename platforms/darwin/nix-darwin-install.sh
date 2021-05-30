#!/usr/bin/env sh

if (! command -v darwin-rebuild); then
    echo "Installing nix-darwin..."

    nix-channel --add https://github.com/LnL7/nix-darwin/archive/master.tar.gz darwin
    nix-channel --update
    export NIX_PATH="darwin-config=$HOME/.nixpkgs/configuration.nix:$NIX_PATH"

    nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer
    ./result/bin/darwin-installer
fi

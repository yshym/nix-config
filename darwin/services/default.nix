{ config, pkgs, ... }: {
  imports = [
    ./imap.nix
    ./skhd.nix
    ./spacebar.nix
    ./spotifyd.nix
    ./yabai.nix
  ];
}

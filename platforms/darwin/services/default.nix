{ config, pkgs, ... }:

{
  imports = [
    ./google-calendar-to-org.nix
    ./imap.nix
    ./skhd.nix
    # ./sortdir.nix
    ./spacebar.nix
    # ./spotifyd.nix
    ./yabai.nix
  ];
}

{ config, pkgs, ... }:

{
  imports = [
    ./google-calendar-to-org.nix
    ./imap.nix
    ./skhd.nix
    ./spacebar.nix
    # ./spotifyd.nix
    ./yabai.nix
  ];
}

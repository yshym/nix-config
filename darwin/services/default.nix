{ config, pkgs, ... }: {
  imports = [
    ./imap
    ./skhd
    ./spacebar
    ./spotifyd
    ./yabai
  ];
}

{ config, pkgs, ... }: {
  imports = [
    ./imap
    ./skhd
    ./spacebar
    ./yabai
  ];
}

{ config, lib, pkgs, ... }:

{
  imports = [ ./scripts ];

  programs = {
    git.enable = true;
    tmux.enable = true;
  };
}

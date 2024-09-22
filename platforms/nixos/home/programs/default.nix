{ config, lib, pkgs, ... }:

{
  imports = [ ./scripts ];

  programs = {
    tmux.enable = true;
  };
}

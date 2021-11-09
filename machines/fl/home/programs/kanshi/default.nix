{ config, lib, pkgs, ... }:

{
  programs.kanshi = {
    enable = true;
    # TODO: Set up kanshi profiles
    # profiles = {};
  };
}

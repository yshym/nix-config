{ config, lib, pkgs, ... }:

{
  services.kanshi = {
    enable = true;
    # TODO: Set up kanshi profiles
    # profiles = {};
  };
}

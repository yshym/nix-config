{ config, lib, pkgs, ... }:

{
  imports = [ ./docker.nix ];

  services = {
    docker.enable = true;
  };
}

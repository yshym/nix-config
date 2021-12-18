{ config, lib, pkgs, ... }:

{
  imports = [ ./kanshi ./redshift.nix ];

  services = { dropbox = { enable = true; }; };
}

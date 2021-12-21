{ config, lib, pkgs, ... }:

{
  imports = [ ./calendar-to-org.nix ./dropbox.nix ./kanshi ./redshift.nix ];

  services = { };
}

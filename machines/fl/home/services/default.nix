{ config, lib, pkgs, ... }:

{
  imports = [ ./kanshi ];

  services = { dropbox = { enable = true; }; };
}

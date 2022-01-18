{ config, lib, pkgs, ... }:

{
  imports = [
    ./calendar-to-org.nix
    ./dropbox.nix
    ./imap.nix
    ./mbsync
    ./kanshi
    ./redshift.nix
    ./spotifyd.nix
  ];

  services = { };
}

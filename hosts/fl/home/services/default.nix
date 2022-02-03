{ lib, pkgs, ... }:

{
  imports = [
    ./calendar-to-org.nix
    ./dropbox.nix
    ./imap.nix
    ./imapnotify.nix
    ./kanshi
    ./redshift.nix
    ./spotifyd.nix
  ];

  services = {
    mbsync.enable = true;
  };
}

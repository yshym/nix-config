{ ... }:

{
  imports = [
    # ./calendar-to-org.nix
    # ./imap.nix
    ./kanshi
    ./redshift.nix
    ./spotifyd.nix
    ./sway
    ./swayidle.nix
    ./hyprland
  ];

  services = {
    # dropbox.enable = true;
    imapnotify.enable = true;
    mbsync.enable = true;
  };
}

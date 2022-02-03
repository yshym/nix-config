{ lib, pkgs, ... }:

{
  home = {
    file.".local/share/TelegramDesktop/tdata/shortcuts-custom.json".source =
      ./shortcuts-custom.json;
    packages = [ pkgs.tdesktop ];
  };
}

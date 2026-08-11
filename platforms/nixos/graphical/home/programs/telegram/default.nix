{ pkgs, ... }:

{
  home = {
    file.".local/share/TelegramDesktop/tdata/shortcuts-custom.json".source =
      ./shortcuts-custom.json;
    packages = [ mv.versions.telegram-desktop."7.0.2" ];
  };
}

{ lib, pkgs, ... }:

with lib.my; {
  imports = mapModules' ./. import;

  programs = {
    brave.enable = true;
    browserpass.enable = true;
    chromium = {
      enable = true;
      package = pkgs.ungoogled-chromium.override {
        commandLineArgs = "--enable-features=UseOzonePlatform --ozone-platform=wayland --force-dark-mode";
      };
    };
    emacs.enable = true;
    firefox.package = pkgs.firefox-wayland;
    mbsync.enable = true;
    mimi.enable = true;
    wofi.enable = true;
    zsh.loginExtra = ''[[ "$(tty)" == /dev/tty1 ]] && sway'';
  };
}

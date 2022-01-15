{ config, lib, pkgs, ... }:

let cfg = config.programs.firefox;
in {
  programs = {
    firefox = {
      enable = true;
      profiles.default = {
        settings = { "browser.search.defaultenginename" = "duckduckgo"; };
        userChrome = builtins.readFile ./userChrome.css;
      };
    };
    zsh.sessionVariables.BROWSER = "firefox";
  };

  home.file.".mozilla/native-messaging-hosts/com.github.browserpass.native.json".source =
    lib.mkIf cfg.enable
    "${pkgs.browserpass}/lib/mozilla/native-messaging-hosts/com.github.browserpass.native.json";
}

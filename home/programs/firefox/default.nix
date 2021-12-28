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

  home.file.".mozilla/native-messaging-hosts/passff.json".source =
    lib.mkIf cfg.enable
    "${pkgs.passff-host}/lib/mozilla/native-messaging-hosts/passff.json";
}

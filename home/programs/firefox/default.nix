{ pkgs, ... }:

{
  programs = {
    firefox = {
      enable = true;
      package = pkgs.firefox-wayland;
      profiles.default = {
        settings = { "browser.search.defaultenginename" = "duckduckgo"; };
        userChrome = builtins.readFile ./userChrome.css;
      };
    };
    zsh.sessionVariables.BROWSER = "firefox";
  };
}

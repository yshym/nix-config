{ pkgs, ... }:

{
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
}

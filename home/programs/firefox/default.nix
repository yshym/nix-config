{ config, lib, pkgs, ... }:

let cfg = config.programs.firefox;
in
{
  programs = {
    firefox = {
      enable = true;
      profiles.default = {
        settings = {
          "browser.search.defaultenginename" = "brave";
          "browser.uidensity" = 1;
          "font.name.monospace.x-western" = "JetBrains Mono";
          "font.name.sans-serif.x-western" = "DejaVu Sans";
          "font.name.serif.x-western" = "DejaVu Serif";
          "font.size.monospace.x-western" = 15;
          "font.size.variable.x-western" = 15;
          "general.smoothScroll.lines.durationMaxMS" = 125;
          "general.smoothScroll.lines.durationMinMS" = 125;
          "general.smoothScroll.mouseWheel.durationMaxMS" = 200;
          "general.smoothScroll.mouseWheel.durationMinMS" = 100;
          "general.smoothScroll.other.durationMaxMS" = 125;
          "general.smoothScroll.other.durationMinMS" = 125;
          "general.smoothScroll.pages.durationMaxMS" = 125;
          "general.smoothScroll.pages.durationMinMS" = 125;
          "mousewheel.system_scroll_override_on_root_content.horizontal.factor" = 175;
          "mousewheel.system_scroll_override_on_root_content.vertical.factor" = 175;
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          "toolkit.scrollbox.horizontalScrollDistance" = 6;
          "toolkit.scrollbox.verticalScrollDistance" = 2;
          "ui.key.menuAccessKeyFocuses" = false;
        };
        userChrome = builtins.readFile ./userChrome.css;
      };
    };
    zsh.sessionVariables.BROWSER = "firefox";
  };
}

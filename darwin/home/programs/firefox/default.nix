{ pkgs, ... }:

{
  nixpkgs.overlays =
    [ (self: super: { Firefox = super.callPackage ./pkg.nix { }; }) ];

  programs = {
    firefox = {
      enable = true;
      package = pkgs.Firefox;
      profiles.default = {
        settings = { "browser.search.defaultenginename" = "duckduckgo"; };
        # userChrome = builtins.readFile ./userChrome.css;
      };
    };
    zsh.sessionVariables.BROWSER = "firefox";
  };
}

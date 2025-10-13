{ pkgs, ... }:

{
  home.packages = [ pkgs.my.Brave pkgs.my.BraveNightly ];
  # programs.zsh.sessionVariables.BROWSER = "brave";
}

{ pkgs, ... }:

{
  home.packages = [ pkgs.my.Brave ];
  # programs.zsh.sessionVariables.BROWSER = "brave";
}

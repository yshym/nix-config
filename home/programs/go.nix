{ config, lib, pkgs, ... }:

let cfg = config.programs.go;
in {
  programs = {
    go.enable = true;
    zsh.shellAliases = {
      golines = "golines -w -m 80";
      gomodifytags = "gomodifytags -add-tags json -all -w -file";
    };
  };

  home.packages = with pkgs; [ gofumpt ];
}

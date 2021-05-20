{ config, lib, pkgs, ... }:

{
  home.file.".mbsyncrc".source = ./.mbsyncrc;
}

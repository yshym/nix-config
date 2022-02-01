{ config, lib, pkgs, ... }:

{
  home-manager.users.yshym = { pkgs, ... }: {
    programs = {
      git.gpgKey = "F79099398148756F";
    };
  };
}


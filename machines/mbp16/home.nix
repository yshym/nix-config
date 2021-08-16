{ config, lib, pkgs, ... }:

{
  home-manager.users.yevhenshymotiuk = { pkgs, ... }: {
    programs = {
      git.gpgKey = "F79099398148756F";
    };
  };
}


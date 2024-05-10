{ config, lib, pkgs, ... }:

{
  home-manager.users.yshym = { pkgs, ... }: {
    programs = {
      browserpass.enable = true;
      emacs.enable = true;
    };
  };
}

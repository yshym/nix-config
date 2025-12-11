{ config, ... }:

{
  home = { pkgs, ... }: {
    programs = {
      browserpass.enable = true;
    };
  };
}

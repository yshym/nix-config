{ inputs, config, lib, pkgs, ... }:

with lib.my; {
  home-manager.users.yshym = { pkgs, ... }: {
    imports = (mapModules' ./. import);
  };
}

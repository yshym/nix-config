{ inputs, config, lib, pkgs, ... }:

with lib.my; {
  home-manager.users.yshym = { pkgs, ... }: {
    imports = [ inputs.hyprland.homeManagerModules.default ] ++ (mapModules' ./. import);
  };
}

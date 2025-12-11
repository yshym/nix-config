{ inputs, config, lib, pkgs, ... }:

with lib.my; {
  home = { pkgs, ... }: {
    imports = [ inputs.hyprland.homeManagerModules.default ] ++ (mapModules' ./. import);
  };
}

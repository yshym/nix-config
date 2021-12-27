{
  description = "Yevhen's dotfiles";

  inputs = {
    nixos.url = "github:yevhenshymotiuk/nixpkgs/nixos-21.11";
    nixpkgs.url = "github:yevhenshymotiuk/nixpkgs/release-21.11";
    darwin.url = "github:yevhenshymotiuk/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:yevhenshymotiuk/home-manager/release-21.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixos, nixpkgs, darwin, home-manager, ... }:
    let
      mkPkgs = pkgs: system: import pkgs { inherit system; };
      mkHost = host: system:
        with mkPkgs nixpkgs system;
        (if stdenv.isDarwin then
          darwin.lib.darwinSystem
        else
          nixos.lib.nixosSystem) {
            system = system;
            modules = [
              home-manager.${
                if stdenv.isDarwin then "darwinModules" else "nixosModules"
              }.home-manager
              self.nixosModules.general
              (./machines + "/${host}")
            ];
          };
    in {
      nixosModules = { general = import ./.; };

      darwinConfigurations = { mbp16 = mkHost "mbp16" "x86_64-darwin"; };

      nixosConfigurations = {
        rpi4 = mkHost "rpi4" "aarch64-linux";
        fl = mkHost "fl" "x86_64-linux";
      };
    };
}

{
  description = "Yevhen's dotfiles";

  inputs = {
    nixos.url = "github:yevhenshymotiuk/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:yevhenshymotiuk/nixpkgs/nixpkgs-unstable";

    darwin.url = "github:yevhenshymotiuk/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:yevhenshymotiuk/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixos, nixpkgs, darwin, home-manager, ... }: {
    darwinConfigurations = {
      mbp16 = darwin.lib.darwinSystem {
        system = "x86_64-darwin";
        modules = [
          home-manager.darwinModules.home-manager
          ./configuration.nix
          ./machines/mbp16
        ];
      };
    };

    nixosConfigurations = {
      rpi4 = nixos.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          home-manager.nixosModules.home-manager
          ./configuration.nix
          ./machines/rpi4
        ];
      };
    };
  };
}

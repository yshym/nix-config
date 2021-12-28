{
  description = "Yevhen's dotfiles";

  inputs = {
    # core
    nixos.url = "github:yevhenshymotiuk/nixpkgs/nixos-21.11";
    nixpkgs.url = "github:yevhenshymotiuk/nixpkgs/release-21.11";
    darwin = {
      url = "github:yevhenshymotiuk/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:yevhenshymotiuk/home-manager/release-21.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # extra
    emacs-overlay.url =
      "github:nix-community/emacs-overlay/9578b9dbce95d9077c2c9b4e06391985670b059c";
  };

  outputs = inputs@{ self, nixos, nixpkgs, darwin, home-manager, ... }:
    let
      inherit (lib.my) mkHost;

      lib = nixpkgs.lib.extend (self: super: {
        my = import ./lib.nix {
          inherit inputs;
          lib = self;
          pkgs = nixpkgs;
        };
      });
    in {
      darwinConfigurations = { mbp16 = mkHost "mbp16" "x86_64-darwin"; };

      nixosConfigurations = {
        rpi4 = mkHost "rpi4" "aarch64-linux";
        fl = mkHost "fl" "x86_64-linux";
      };
    };
}

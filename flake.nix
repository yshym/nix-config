{
  description = "Yevhen's dotfiles";

  inputs = {
    # core
    nixos.url = "github:yshym/nixpkgs/nixos-21.11";
    nixpkgs.url = "github:yshym/nixpkgs/release-21.11";
    nixos-unstable.url = "github:yshym/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:yshym/nixpkgs/nixpkgs-unstable";
    darwin = {
      url = "github:yshym/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:yshym/home-manager/release-21.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # extra
    emacs-overlay.url = "github:nix-community/emacs-overlay";
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

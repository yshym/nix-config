{
  description = "Yevhen's dotfiles";

  inputs = {
    # core
    nixos.url = "nixpkgs/nixos-21.11";
    nixpkgs.url = "nixpkgs/release-21.11";
    nixpkgs-unstable.url = "nixpkgs/nixpkgs-unstable";
    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-21.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # extra
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    flake-utils.url = "github:numtide/flake-utils";
    nixos-hardware.url = "github:nixos/nixos-hardware/master";
  };

  outputs =
    inputs@{ self, nixos, nixpkgs, darwin, home-manager, flake-utils, ... }:
    let
      inherit (lib) foldr optional optionalAttrs;
      inherit (lib.my) isDarwin mkHost mkPkgs mapModules;
      inherit (flake-utils.lib) eachDefaultSystem;

      lib = nixpkgs.lib.extend (self: super: {
        my = import ./lib {
          inherit inputs;
          lib = self;
          # TODO Substitute with OS-independent counterpart
          pkgs = mkPkgs "x86_64-linux";
        };
      });
    in
    eachDefaultSystem
      (system:
      let
        pkgs = mkPkgs system;
        paths = [
          ./packages
          (if (isDarwin system) then ./packages/darwin else ./packages/linux)
        ];
      in
      {
        packages = foldr (a: b: a // b) { }
          (map (path: mapModules (toString path) (p: pkgs.callPackage p { }))
            paths);

        defaultApp = {
          type = "app";
          program = ./home/programs/scripts/bin/h;
        };
      }) // {
      lib = lib.my;

      overlays = { emacs = inputs.emacs-overlay.overlay; };

      darwinConfigurations = { mbp16 = mkHost "mbp16" "x86_64-darwin"; };

      nixosConfigurations = {
        rpi4 = mkHost "rpi4" "aarch64-linux";
        fl = mkHost "fl" "x86_64-linux";
      };
    };
}

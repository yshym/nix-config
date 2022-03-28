{
  description = "Yevhen's dotfiles";

  inputs = {
    # core
    nixos.url = "github:yshym/nixpkgs/nixos-21.11";
    nixpkgs.url = "github:yshym/nixpkgs/release-21.11";
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
    emacs-overlay.url = "github:yshym/emacs-overlay";
    flake-utils.url = "github:numtide/flake-utils";
    nixos-hardware.url = "nixos-hardware/master";
  };

  outputs =
    inputs@{ self, nixos, nixpkgs, darwin, home-manager, flake-utils, ... }:
    let
      inherit (flake-utils.lib) eachDefaultSystem;

      mkHost = hostname: system:
        let
          pkgs = import inputs.nixpkgs { inherit system; };
          lib = nixpkgs.lib.extend (self: super: {
            my = import ./lib { inherit inputs pkgs; lib = self; };
          });
        in
        lib.my.mkHost hostname system;
    in
    eachDefaultSystem
      (system:
      let
        inherit (nixpkgs.lib) foldr;
        inherit (mylib) isDarwin mapModules;

        lib = nixpkgs.lib;
        pkgs = import inputs.nixpkgs { inherit system; };
        mylib = import ./lib { inherit inputs lib pkgs; };
        paths = [
          ./packages
          (if (isDarwin system) then ./packages/darwin else ./packages/linux)
        ];
      in
      {
        lib = mylib;

        packages = foldr (a: b: a // b) { }
          (map (path: mapModules (toString path) (p: pkgs.callPackage p { }))
            paths);

        defaultApp = {
          type = "app";
          program = ./home/programs/scripts/bin/h;
        };
      }) // {
      overlays = { emacs = inputs.emacs-overlay.overlay; };

      darwinConfigurations = { mbp16 = mkHost "mbp16" "x86_64-darwin"; };

      nixosConfigurations = {
        rpi4 = mkHost "rpi4" "aarch64-linux";
        fl = mkHost "fl" "x86_64-linux";
      };
    };
}

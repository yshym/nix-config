{ inputs, lib, pkgs, ... }:

with pkgs; {
  imports = [ ./cachix ];

  environment.systemPackages = [ bash coreutils gcc git ripgrep vim wget ];

  fonts.packages = [
    dejavu_fonts
    fira-code
    font-awesome
    jetbrains-mono
    (joypixels.override { acceptLicense = true; })
    noto-fonts
    noto-fonts-cjk-sans
  ];

  nix = {
    package = pkgs.nixVersions.nix_2_19;
    settings = {
      sandbox = true;
      trusted-users = [ "root" "yshym" ];
    };
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
  };

  programs = {
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  time.timeZone = "Europe/Kiev";
}

{ inputs, lib, pkgs, ... }:

with pkgs; {
  imports = [ ./cachix ];

  environment.systemPackages = [ coreutils gcc ripgrep vim wget ];

  fonts = {
    fonts = [
      dejavu_fonts
      fira-code
      font-awesome
      jetbrains-mono
      (joypixels.override { acceptLicense = true; })
      noto-fonts
      noto-fonts-cjk
    ];
    fontconfig.defaultFonts = {
      monospace = [ "JetBrains Mono" ];
      serif = [ "DejaVu Serif" ];
      sansSerif = [ "DejaVu Sans" ];
    };
  };

  nix = {
    package = pkgs.nixFlakes;
    trustedUsers = [ "root" "yshym" ];
    useSandbox = true;
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

  system.stateVersion = "22.05";
}

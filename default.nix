{ inputs, pkgs, ... }:

with pkgs; {
  imports = [ ./cachix ];

  environment.systemPackages = [ coreutils gcc ripgrep vim wget ];

  fonts.fonts =
    [ fira-code font-awesome jetbrains-mono noto-fonts-cjk noto-fonts-emoji ];

  nix = {
    package = pkgs.nixFlakes;
    trustedUsers = [ "root" "yshym" ];
    useSandbox = true;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  programs = {
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  time.timeZone = "Europe/Kiev";
}

{ config, pkgs, ... }:

{
  home-manager.useUserPackages = false;
  environment.homeBinInPath = true;

  users = {
    # Disable ad-hoc user management.
    mutableUsers = false;

    users.yevhenshymotiuk = {
      isNormalUser = true;
      extraGroups = [ "sudo" "wheel" ];
      openssh.authorizedKeys.keyFiles = [ ./ssh/mbp16.pub ];
      shell = pkgs.zsh;
    };
  };

  home-manager.users.yevhenshymotiuk = { pkgs, ... }: {
    imports = [ ./packages.nix ];

    nixpkgs.config = {
      allowUnfree = true;
      pulseaudio = true;
    };

    programs = {
      gpg.enable = true;
    };
  };
}

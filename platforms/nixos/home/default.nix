{ config, pkgs, ... }:

{
  environment.homeBinInPath = true;

  users = {
    # Disable ad-hoc user management.
    mutableUsers = false;

    users.yevhenshymotiuk = {
      hashedPassword =
        "$6$i3YXp5DMdXqRt$WjzYcieb8JAzGyL19GSXjKZ80/8zvNnPaVjAnvxoz.6xJRrxMlQghBoJ37d4j2muwmuFjNXYf4nquYqOhlZUz/";
      isNormalUser = true;
      extraGroups = [ "sudo" "wheel" ];
      openssh.authorizedKeys.keyFiles = [ ./ssh/mbp16.pub ];
      shell = pkgs.zsh;
    };
  };

  home-manager = {
    users.yevhenshymotiuk = { pkgs, ... }: {
      imports = [ ./packages.nix ./services ];

      nixpkgs.config = {
        allowUnfree = true;
        pulseaudio = true;
      };

      programs = {
        git.enable = true;
        gpg.enable = true;
      };
    };
  };
}

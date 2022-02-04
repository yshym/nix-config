{ config, pkgs, ... }:

{
  environment.homeBinInPath = true;

  users = {
    # Disable ad-hoc user management.
    mutableUsers = false;

    users.yshym = {
      hashedPassword =
        "$6$i3YXp5DMdXqRt$WjzYcieb8JAzGyL19GSXjKZ80/8zvNnPaVjAnvxoz.6xJRrxMlQghBoJ37d4j2muwmuFjNXYf4nquYqOhlZUz/";
      isNormalUser = true;
      extraGroups = [ "audio" "i2c" "sudo" "video" "wheel" ];
      openssh.authorizedKeys.keyFiles = [ ./ssh/fl.pub ];
      shell = pkgs.zsh;
    };
  };

  home-manager = {
    users.yshym = { pkgs, ... }: {
      imports = [ ./packages.nix ./programs ];
    };
  };
}

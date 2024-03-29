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
      extraGroups = [ "audio" "i2c" "plugdev" "sudo" "video" "wheel" "user-with-access-to-virtualbox" ];
      openssh.authorizedKeys.keyFiles = [ ./ssh/fl.pub ./ssh/mbp.pub ];
      shell = pkgs.zsh;
    };
  };

  home-manager = {
    users.yshym = { pkgs, ... }: {
      imports = [ ./packages.nix ./programs ];
    };
  };
}

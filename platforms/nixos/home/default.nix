{ pkgs, ... }:

{
  environment.homeBinInPath = true;

  # Disable ad-hoc user management.
  users.mutableUsers = false;

  user = {
    hashedPassword =
      "$6$i3YXp5DMdXqRt$WjzYcieb8JAzGyL19GSXjKZ80/8zvNnPaVjAnvxoz.6xJRrxMlQghBoJ37d4j2muwmuFjNXYf4nquYqOhlZUz/";
    isNormalUser = true;
    extraGroups = [ "audio" "i2c" "plugdev" "sudo" "video" "wheel" "user-with-access-to-virtualbox" ];
    openssh.authorizedKeys.keyFiles = [ ./ssh/fl.pub ./ssh/mbp.pub ];
    shell = pkgs.zsh;
  };

  home = { pkgs, ... }: {
    imports = [ ./packages.nix ./programs ];
  };
}

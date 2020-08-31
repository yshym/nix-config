{ pkgs, ... }: {
  home.packages = with pkgs; [ ranger w3m-full ];

  xdg.configFile = {
    "ranger/rc.conf".source = ./rc.conf;
    "ranger/rifle.conf".source = ./rifle.conf;
  };
}

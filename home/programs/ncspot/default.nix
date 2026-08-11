{ mv, ... }:

{
  home.packages = [ mv.versions.ncspot."1.3.4" ];

  xdg.configFile."ncspot/config.toml".source = ./config.toml;
}

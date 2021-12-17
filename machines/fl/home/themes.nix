{ pkgs, ... }:

with pkgs; {
  gtk = {
    enable = true;
    iconTheme = {
      name = "Pop";
      package = pop-icon-theme;
    };
    theme = {
      name = "Pop-dark";
      package = pop-gtk-theme;
    };
    font = { name = "Fira Mono"; size = 8; };
    gtk3.extraConfig = {
      gtk-cursor-theme-name = "Bibata_Oil";
      gtk-cursor-theme-size = 20;
    };
  };
  qt = {
    enable = true;
    platformTheme = "gtk";
  };

  home.packages = [ dconf bibata-cursors ];
}

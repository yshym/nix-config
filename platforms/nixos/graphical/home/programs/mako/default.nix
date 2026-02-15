{ pkgs, ... }:

{
  services.mako = {
    enable = true;
    settings = {
      sort = "+time";
      anchor = "top-right";
      width = 250;
      font = if pkgs.stdenv.isAarch64 then "Fira Code 12" else "Fira Code 9";
      backgroundColor = "#282a36";
      textColor = "#f8f8f2";
      borderSize = 2;
      borderColor = "#44475a";
      defaultTimeout = 5000;
    };
  };
}

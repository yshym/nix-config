{ pkgs, ... }:

{
  services.mako = {
    enable = true;
    settings = {
      sort = "+time";
      anchor = "top-right";
      width = 250;
      font = if pkgs.stdenv.isAarch64 then "Fira Code 12" else "Fira Code 9";
      background-color = "#282a36";
      text-color = "#f8f8f2";
      border-size = 2;
      border-color = "#44475a";
      default-timeout = 5000;
    };
  };
}

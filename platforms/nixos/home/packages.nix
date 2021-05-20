{ pkgs, ... }:

{
  home.packages = with pkgs;
    let
      comma = (import (builtins.fetchTarball
        "https://github.com/Shopify/comma/archive/master.tar.gz") { });
    in [
      comma

      # passwords & security
      pass
      pinentry
    ];
}

{ config, pkgs, ... }:

{
  users.users.yevhenshymotiuk = {
    name = "yevhenshymotiuk";
    home = "/Users/yevhenshymotiuk";
  };

  home-manager = {
    useUserPackages = false;
    users.yevhenshymotiuk = {pkgs, ...}: {
      imports = [ ./packages.nix ./programs ];
    };
  };
}

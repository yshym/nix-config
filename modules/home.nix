{ config, lib, ... }:

with lib;
{
  imports = [
    (mkAliasOptionModule [ "home" ] [ "home-manager" "users" config.user.name ])
  ];
}

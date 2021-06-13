{ config, lib, pkgs, ... }:

{
  home-manager.users.yevhenshymotiuk = { pkgs, ... }: {
    home.packages = with pkgs; [ elixir erlang ];
  };
}

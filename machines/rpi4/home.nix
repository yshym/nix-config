{ config, lib, pkgs, ... }:

{
  home-manager.users.yevhenshymotiuk = { pkgs, ... }: {
    home.packages = with pkgs; [ elixir erlang ];
    programs = {
        git.gpgKey = "1646BDE9047380DF";
    };
  };
}

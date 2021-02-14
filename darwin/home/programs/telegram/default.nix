{ config, lib, pkgs, ... }:

{
  home.file = {
    "Library/Application Support/Telegram Desktop/tdata/shortcuts-custom.json" = {
      source = ./shortcuts-custom.json;
    };
  };
}

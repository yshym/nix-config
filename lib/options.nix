{ lib, ... }:

let
  inherit (lib) mkOption;
in
{
  mkOpt = type: default:
    mkOption { inherit type default; };
}

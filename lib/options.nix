{ lib, ... }:

let
  inherit (lib) mkOption;
in
{
  # mkOpt :: type -> default -> option
  #
  # Shorthand for mkOption with just a type and default value.
  mkOpt = type: default:
    mkOption { inherit type default; };
}

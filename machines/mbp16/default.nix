{ config, lib, pkgs, ... }:

{
  imports = [ ../../platforms/darwin ];

  networking.hostName = "mbp16";
}

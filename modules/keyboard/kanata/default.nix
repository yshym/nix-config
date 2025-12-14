{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.keyboard.kanata;
  port = 10000;
  configFile = pkgs.writeTextFile {
    name = "config.kbd";
    text = builtins.readFile ./kanata.kbd;
    checkPhase = ''
      ${pkgs.kanata}/bin/kanata --cfg "$target" --check --debug
    '';
  };
in
{
  options.modules.keyboard.kanata = {
    enable = mkEnableOption "Kanata software keyboard remapper";
  };

  config = mkIf cfg.enable {
    home.xdg.configFile."kanata/kanata.kbd".source = configFile;
    user.packages = with pkgs; [ kanata ];

    modules.keyboard.karabiner-dk.enable = true;

    launchd.daemons.kanata = mkIf pkgs.stdenv.isDarwin {
      command = "${pkgs.kanata}/bin/kanata --cfg ${configFile} --port ${toString port}";
      serviceConfig = {
        RunAtLoad = true;
        KeepAlive = true;
        ProcessType = "Interactive";
      };
    };
    system.activationScripts.postActivation.text = mkIf pkgs.stdenv.isDarwin (mkAfter ''
      launchctl kickstart -k system/org.nixos.kanata
    '');
  };
}

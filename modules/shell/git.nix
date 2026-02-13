{ config, lib, pkgs, ... }:

with lib;
let cfg = config.modules.shell.git;
in
{
  options.modules.shell.git = {
    enable = mkEnableOption "Git";
  };

  config = mkIf cfg.enable {
    home = {
      programs = {
        delta = {
          enable = true;
          enableGitIntegration = true;
        };
        git = {
          enable = true;
          signing = {
            key = "4B0D9393F36E588A";
            signByDefault = true;
          };
          settings = {
            alias = {
              up = "pull --rebase --autostash";
            };
            user = {
              name = "Yevhen Shymotiuk";
              email = "yshym@pm.me";
            };
            extraConfig = {
              github.user = "yshym";
            };
          };
        };
        # zsh.shellAliases.git = "hub";
      };
      home.file.gitignore = {
        target = ".gitignore";
        text = ''
          .zsh/.completions
          .zsh/plugins.zsh
        '';
      };
    };
    user.packages = with pkgs; [ bfg-repo-cleaner git-secrets git-standup ];
  };
}

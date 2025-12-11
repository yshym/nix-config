{ config, lib, pkgs, ... }:

with lib;
let cfg = config.modules.shell.git;
in
{
  options.modules.shell.git = {
    enable = mkEnableOption false;
    pager = mkOption {
      type = with types; (nullOr (enum [ "delta" "diff-so-fancy" ]));
      default = null;
    };
  };

  config = mkIf cfg.enable {
    home = {
      programs = {
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
              core.pager =
                if cfg.pager == "delta" then
                  "delta --dark"
                else if cfg.pager == "diff-so-fancy" then
                  "diff-so-fancy | less --tabs=4 -RFX"
                else
                  null;
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
    user.packages = with pkgs;
      ([ bfg-repo-cleaner git-secrets git-standup ]
        ++ (optional (cfg.pager == "delta") delta)
        ++ (optional (cfg.pager == "diff-so-fancy") diff-so-fancy));
  };
}

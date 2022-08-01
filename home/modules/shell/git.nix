{ config, lib, pkgs, ... }:

with lib;
let cfg = config.programs.git;
in
{
  options.programs.git = {
    pager = mkOption {
      type = with types; (nullOr (enum [ "delta" "diff-so-fancy" ]));
      default = null;
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs.gitAndTools;
        ([ bfg-repo-cleaner git-standup hub ]
          ++ (optional (cfg.pager == "delta") delta)
          ++ (optional (cfg.pager == "diff-so-fancy") diff-so-fancy));
      file.gitignore = {
        target = ".gitignore";
        text = ''
          .zsh/.completions
          .zsh/plugins.zsh
        '';
      };
    };

    programs = {
      git = {
        aliases = {
          up = "pull --rebase --autostash";
        };
        signing = {
          key = "4B0D9393F36E588A";
          signByDefault = true;
        };
        userName = "Yevhen Shymotiuk";
        userEmail = "yshym@pm.me";
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
      zsh.shellAliases.git = "hub";
    };
  };
}

{ config, lib, pkgs, ... }:
with lib;
let cfg = config.programs.git;
in {
  options.programs.git = {
    pager = mkOption {
      type = with types; (nullOr (enum [ "delta" "diff-so-fancy" ]));
      default = null;
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs.gitAndTools;
      ([ bfg-repo-cleaner git-standup hub ]
        ++ (optional (cfg.pager == "delta") delta)
        ++ (optional (cfg.pager == "diff-so-fancy") diff-so-fancy));

    home.file.gitignore = {
      target = ".gitignore";
      text = ''
        .zsh/.completions
        .zsh/plugins.zsh
      '';
    };

    programs.git = {
      aliases = {
        mr = ''
          !sh -c 'git fetch $1 merge-requests/$2/head:mr-$1-$2 && git checkout mr-$1-$2' -
        '';
        up = "pull --rebase --autostash";
      };
      signing = {
        key = "F79099398148756F";
        signByDefault = true;
      };
      userName = "Yevhen Shymotiuk";
      userEmail = "yevhenshymotiuk@gmail.com";
      extraConfig = {
        core.pager = if (cfg.pager == "delta") then
          "delta --dark"
        else if (cfg.pager == "diff-so-fancy") then
          "diff-so-fancy | less --tabs=4 -RFX"
        else
          null;
        github.user = "yevhenshymotiuk";
      };
    };
  };
}

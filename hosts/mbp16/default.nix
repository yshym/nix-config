{ pkgs, ... }:

{
  imports = [ ../../platforms/darwin ./home.nix ];

  user.name = "yshym";

  services = {
    postgresql = {
      enable = true;
      dataDir = "/usr/local/var/postgres";
    };
  };

  modules = {
    dev = {
      python = {
        enable = true;
        extraPackages = with pkgs.python3Packages; [ python-lsp-server ];
        black = {
          enable = false;
          settings.line-length = 79;
        };
        mypy = {
          enable = true;
          settings.ignore_missing_imports = true;
        };
        pylint.enable = false;
      };
    };
    editors.emacs.enable = true;
    shell = {
      git = {
        enable = true;
        pager = "diff-so-fancy";
      };
      man.enable = true;
    };
  };
}

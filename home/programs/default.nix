{ config, lib, pkgs, ... }:

{
  imports = [
    ./alacritty
    ./bat.nix
    ./direnv
    ./exa.nix
    ./firefox
    ./go.nix
    ./password-store.nix
    ./scripts
    # ./topgrade
    ./vim.nix
    ./zathura.nix
    ./zoxide.nix
    ./zsh
  ];

  programs = {
    git = {
      enable = true;
      pager = "diff-so-fancy";
    };
    man.enable = true;
    nodejs = {
      enable = true;
      yarn.enable = true;
    };
    prettier.enable = true;
    python = {
      enable = true;
      black = {
        enable = false;
        settings.line-length = 79;
      };
      mypy = {
        enable = true;
        settings.ignore_missing_imports = true;
      };
      pylint.enable = false;
      extraPackages = with pkgs.python3Packages; [ python-lsp-server ];
    };
    ripgrep = {
      enable = true;
      # NOTE Arguments break ripgrep in Emacs
      # arguments = [
      #   "--max-columns=150"
      #   "--max-columns-preview"
      #   "--type-add web:*.{html,css,js}*"
      #   "--smart-case"
      # ];
    };
    ruby = {
      enable = false;
      enableBuildLibs = true;
      provider = "nixpkgs";
      enableSolargraph = true;
    };
    tmux = {
      enable = true;
      shell = "${pkgs.zsh}/bin/zsh";
      sensibleOnTop = false;
      keyMode = "vi";
      customPaneNavigationAndResize = true;
      clock24 = true;
      plugins = with pkgs.tmuxPlugins; [
        yank
        {
          plugin = dracula;
          extraConfig = ''
            set -g @dracula-plugins " "
            set -g @dracula-show-powerline true
            set -g @dracula-show-left-icon "#h | #S"
            set -g @dracula-refresh-rate 10
          '';
        }
      ];
    };
  };
}

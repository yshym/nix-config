{ pkgs, lib, ... }:

{
  # imports = [ ./forgit.nix ];

  home.packages = with pkgs; [ zsh-completions zsh-powerlevel10k ];

  home.file.".zsh_completions".source = ./completions;
  home.file.".p10k-pure.zsh".source = ./p10k-pure.zsh;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autocd = true;
    loginExtra = lib.optionalString pkgs.stdenv.isLinux ''
      ssh-add $HOME/.ssh/id_ed25519 &> /dev/null
    '';
    initExtra = ''
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      source ~/.p10k-pure.zsh

      bindkey -M emacs '^K' history-substring-search-up
      bindkey '^[[A' history-substring-search-up
      bindkey -M emacs '^J' history-substring-search-down
      bindkey '^[[B' history-substring-search-down
    '';
    envExtra = ''
      fpath+=$HOME/.zsh_completions

      export ERL_AFLAGS="-kernel shell_history enabled"
      export PYENV_ROOT="$HOME/.pyenv"

      export GOPATH="$HOME/go"
      # export DARTPATH=$(dirname $(dirname $(readlink $(which dart))))

      export PATH="$PYENV_ROOT/bin:$PATH"
      export PATH="$HOME/.mix/escripts:$PATH"
      export PATH="$GOPATH/bin:$PATH"
      export PATH="$HOME/.local/bin:$PATH"
    '';
    history.size = 1000;
    plugins = with pkgs; [
      rec {
        name = "fast-syntax-highlighting";
        src = fetchFromGitHub {
          owner = "zdharma";
          repo = name;
          rev = "v1.55";
          sha256 = "0h7f27gz586xxw7cc0wyiv3bx0x3qih2wwh05ad85bh2h834ar8d";
        };
      }
      rec {
        name = "zsh-history-substring-search";
        src = fetchFromGitHub {
          owner = "zsh-users";
          repo = name;
          rev = "v1.0.2";
          sha256 = "0y8va5kc2ram38hbk2cibkk64ffrabfv1sh4xm7pjspsba9n5p1y";
        };
      }
      rec {
        name = "zsh-z";
        src = fetchFromGitHub {
          owner = "agkozak";
          repo = name;
          rev = "595c883abec4682929ffe05eb2d088dd18e97557";
          sha256 = "sha256-HnwUWqzwavh/Qox+siOe5lwTp7PBdiYx+9M0NMNFx00=";
        };
      }
    ];
    shellAliases = {
      cat = "bat";
      cdr = "cd $(git rev-parse --show-toplevel)";
      drel = "direnv reload";
      nrs = if pkgs.stdenv.isDarwin then
        "darwin-rebuild switch"
      else
        "nixos-rebuild switch";
      git = "hub";
      golines = "golines -w -m 80";
      gomodifytags = "gomodifytags -add-tags json -all -w -file";
      grep = "rg";
      ls = "exa --group-directories-first";
      tg = "topgrade -y";
    };
  };
}

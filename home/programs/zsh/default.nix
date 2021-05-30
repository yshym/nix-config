{ pkgs, lib, ... }:

with pkgs; {
  home.packages = [ zsh-completions zsh-powerlevel10k ];

  home.file.".zsh_completions".source = ./completions;

  programs.zsh = {
    enable = true;
    enableCompletion = false;
    autocd = true;
    loginExtra = lib.optionalString stdenv.isLinux ''
      ssh-add $HOME/.ssh/id_ed25519 &> /dev/null
    '';
    initExtra = ''
      source ${zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      source ${zsh-powerlevel10k}/share/zsh-powerlevel10k/config/p10k-pure.zsh

      autoload -Uz compinit
      if [${
        if stdenv.isDarwin then
          " $(date +'%j') != $(stat -f '%Sm' -t '%j' ~/.zcompdump) "
        else
          "[ -n $ZDOTDIR/.zcompdump(#qN.mh+24) ]"
      }]; then
        compinit -i
      else
        compinit -C
      fi

      zstyle ':completion:*' \
        matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
      zstyle ':completion:*' menu select

      bindkey "^A"   beginning-of-line             # ctrl-a
      bindkey "^E"   end-of-line                   # ctrl-e
      bindkey "^[f"  forward-word                  # alt-f
      bindkey "^[b"  backward-word                 # alt-b
      bindkey "^[d"  kill-word                     # alt-d
      bindkey "^K"   history-substring-search-up   # ctrl-k
      bindkey "^J"   history-substring-search-down # ctrl-j
      bindkey "^[[A" history-substring-search-up   # up arrow
      bindkey "^[[B" history-substring-search-down # down arrow
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
    plugins = [
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
      dhook = ''eval "$(direnv hook zsh)"'';
      drel = "direnv reload";
      git = "hub";
      golines = "golines -w -m 80";
      gomodifytags = "gomodifytags -add-tags json -all -w -file";
      grep = "rg";
      ls = "exa --group-directories-first";
      nrs = "${if stdenv.isDarwin then "darwin" else "nixos"}-rebuild switch";
      o = lib.optionalString stdenv.isDarwin "open";
      tg = "topgrade -y";
    };
  };
}

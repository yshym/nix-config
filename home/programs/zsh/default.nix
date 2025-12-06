{ pkgs, lib, ... }:

with pkgs; {
  programs.zsh = {
    enable = true;
    enableCompletion = false;
    autocd = true;
    initContent = ''
      source ${zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      source ${zsh-powerlevel10k}/share/zsh-powerlevel10k/config/p10k-pure.zsh

      ${lib.optionalString stdenv.isDarwin ''
      # Use GNU utils
      export PATH="${coreutils}/bin:$PATH"''}

      setopt extendedglob
      [ -z "$ZDOTDIR" ] && export ZDOTDIR="$HOME"
      autoload -Uz compinit
      if [[ ${
        if stdenv.isDarwin then
          "$(date +'%j') != $(date -d @\"$(stat -c '%Y' \"$ZDOTDIR/.zcompdump\")\" +'%j')"
        else
          "-n $ZDOTDIR/.zcompdump(#qN.mh+24)"
      } ]]; then
        compinit -i
      else
        compinit -C
      fi
      unsetopt extendedglob

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
      ${lib.optionalString stdenv.isDarwin ''eval "$(/opt/homebrew/bin/brew shellenv)"''}

      export GPG_TTY="$(tty)"

      export ERL_AFLAGS="-kernel shell_history enabled"
      export PYENV_ROOT="$HOME/.pyenv"

      export GOPATH="$HOME/go"
      # export DARTPATH=$(dirname $(dirname $(readlink $(which dart))))

      export PATH="$PYENV_ROOT/bin:$PATH"
      export PATH="$HOME/.mix/escripts:$PATH"
      export PATH="$GOPATH/bin:$PATH"
      export PATH="/etc/profiles/per-user/$USER/bin:$PATH"
      export PATH="$HOME/.config/emacs/bin:$PATH"
      # TODO Package wtwitch
      export PATH="$HOME/dev/wtwitch/src:$PATH"
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
          rev = "v1.1.0";
          sha256 = "sha256-GSEvgvgWi1rrsgikTzDXokHTROoyPRlU0FVpAoEmXG4=";
        };
      }
      # rec {
      #   name = "zsh-vi-mode";
      #   src = fetchFromGitHub {
      #     owner = "jeffreytse";
      #     repo = name;
      #     rev = "v0.12.0";
      #     sha256 = "sha256-EYr/jInRGZSDZj+QVAc9uLJdkKymx1tjuFBWgpsaCFw=";
      #   };
      # }
    ];
    shellAliases = {
      docker-stop-all = "docker stop $(docker ps -a -q)";
      du = "${pkgs.dust}/bin/dust";
      la = "ls -a";
      ll = "ls -l";
      lla = "ls -al";
      md = "mkdir -p";
      nrs = "${if stdenv.isDarwin then "darwin" else "nixos"}-rebuild switch";
      o = if stdenv.isDarwin then "open" else "xdg-open";
      rf = "rm -rf";
      rd = "rmdir";
      shfmt = "${pkgs.shfmt}/bin/shfmt -bn -ci -sr -i 4 -w";
      srf = "sudo rm -rf";
      top = "${pkgs.bottom}/bin/btm";
    };
  };

  home = {
    file.".zsh_completions".source = ./completions;
    file.".hushlogin".text = "";
    packages = [ zsh-completions ];
  };
}

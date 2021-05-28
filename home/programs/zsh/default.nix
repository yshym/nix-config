{ pkgs, lib, ... }:

{
  # imports = [ ./forgit.nix ];

  home.packages = with pkgs; [ zsh-completions ];

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
      export HISTSIZE=1000
      export SAVEHIST=1000

      source ~/.p10k-pure.zsh
      if command -v pyenv 1> /dev/null 2>&1; then
        eval "$(pyenv init -)"
      fi
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
    oh-my-zsh = {
      enable = true;
      plugins = [ "docker" "docker-compose" "wd" "z" ];
    };
    prezto = {
      enable = true;
      pmodules = [
        "editor"
        "spectrum"
        "utility"
        "completion"
        "history-substring-search"
        "docker"
        "git"
        "prompt"
      ];
      editor.keymap = "emacs";
      prompt.theme = "powerlevel10k";
    };
    plugins = with pkgs; [rec {
      name = "fast-syntax-highlighting";
      src = fetchFromGitHub {
        owner = "zdharma";
        repo = name;
        rev = "5351bd907ea39d9000b7bd60b5bb5b0b1d5c8046";
        sha256 = "0h7f27gz586xxw7cc0wyiv3bx0x3qih2wwh05ad85bh2h834ar8d";
      };
    }];
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

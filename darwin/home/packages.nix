{ pkgs, ... }:

{
  home.packages = with pkgs;
    let
      myNodePackages = with nodePackages; [
        # deno
        prettier
        serverless
      ];
      comma = (import (builtins.fetchTarball
        "https://github.com/Shopify/comma/archive/master.tar.gz") { });
    in [
      # development
      alacritty
      asciinema
      awscli
      cachix
      caddy
      ccls
      chromedriver
      clang-tools
      cmake
      dart
      editorconfig-core-c
      elixir
      erlang
      exercism
      gdb
      ghc
      gitAndTools.git-hub
      gitAndTools.gh
      glib
      gnupg
      gobject-introspection
      gofumpt
      imagemagick
      iterm2
      ix
      jq
      kubectl
      libpng
      lld_10
      lua
      luaPackages.lua-lsp
      minikube
      nasm
      nim
      octave
      openmpi
      pipenv
      protobuf
      pkg-config
      redis
      rnix-lsp
      ruby
      sass
      shellcheck
      shfmt
      terminal-notifier
      texlive.combined.scheme-full
      # spacevim
      wakatime

      # nix stuff
      comma
      fd
      nix-index
      nix-prefetch-github
      nixpkgs-review
      nixfmt
      patchelf

      # documents
      graphviz
      pandoc

      # other ART (Awesome Rust Tools)
      exa
      diskus
      du-dust
      fd
      ffsend
      hexyl
      hyperfine
      just
      lsd
      pastel
      ruplacer
      sd
      tealdeer
      tokei
      websocat
      xsv
      zola

      # communication
      goimapnotify
      isync
      mu
      offlineimap
      tmate

      # monitoring
      neofetch
      gotop
      speedtest-cli

      # passwords & security
      gopass
      pass

      # net & cloud tools
      ddgr
      doctl
      httpie
      netcat
      rclone
      telnet
      transmission-gtk

      # entertainment
      epr
      mpv
      portaudio
      spotifyd
      spotify-tui
      streamlink
      youtube-dl

      # my stuff
      navi
      translate-shell
    ] ++ myNodePackages;
}

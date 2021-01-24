{ pkgs, ... }:

{
  home.packages = with pkgs;
    let
      myNodePackages = with nodePackages; [
        deno
        prettier
        serverless
      ];
      comma = (import (builtins.fetchTarball
        "https://github.com/Shopify/comma/archive/master.tar.gz") { });
    in [
      # development
      asciinema
      awscli
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
      protobuf
      pkg-config
      R
      redis
      rnix-lsp
      ruby
      sass
      shellcheck
      shfmt
      terminal-notifier
      texlive.combined.scheme-full
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
      mu
      offlineimap
      slack

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

      # synchronization
      borgbackup

      # entertainment
      epr
      mpv
      spotifyd
      spotify-tui
      youtube-dl

      # my stuff
      translate-shell
    ] ++ myNodePackages;
}

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
      asciinema
      awscli
      caddy2
      ccls
      chromedriver
      clang-tools
      crystal
      editorconfig-core-c
      elixir
      erlang
      exercism
      fd
      gdb
      gitAndTools.git-hub
      ghc
      glib
      gobject-introspection
      ix
      kubectl
      litecli
      lld_10
      lua
      minikube
      nasm
      nim
      openmpi
      protobuf
      pkg-config
      redis
      ruby
      sass
      shellcheck
      shfmt
      texlive.combined.scheme-full
      wakatime
      openjdk8

      # nix stuff
      comma
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
      # du-dust
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
      youtube-dl

      # my stuff
      translate-shell
    ] ++ myNodePackages;
}

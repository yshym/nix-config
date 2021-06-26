{ pkgs, ... }:

{
  home.packages = with pkgs;
    let
      myNodePackages = with nodePackages; [
        prettier
        serverless
      ];
      comma = (import (builtins.fetchTarball
        "https://github.com/Shopify/comma/archive/master.tar.gz") { });
    in [
      # development
      asciinema
      awscli
      cachix
      caddy
      ccls
      clang-tools
      cmake
      dart
      # deno
      editorconfig-core-c
      elixir
      erlang
      exercism
      gawk
      gdb
      ghc
      gitAndTools.git-hub
      gitAndTools.gh
      glib
      gnupg
      gobject-introspection
      gofumpt
      imagemagick
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
      texlive.combined.scheme-full
      wakatime

      # nix stuff
      comma
      fd
      nixfmt
      nix-index
      nix-prefetch-github
      nixpkgs-fmt
      nixpkgs-review
      patchelf

      # documents
      graphviz
      pandoc

      # other ART (Awesome Rust Tools)
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
      pinentry

      # net & cloud tools
      ddgr
      doctl
      httpie
      netcat
      rclone
      telnet
      transmission

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

{ pkgs, ... }:

{
  home.packages = with pkgs;
    let
      myEmacs = (emacs.override {
        withGTK3 = true;
        withGTK2 = false;
      });
      myNodePackages = with nodePackages; [ deno prettier serverless ];
      comma = (import (builtins.fetchTarball
        "https://github.com/Shopify/comma/archive/master.tar.gz") { });
    in [
      # development
      ameba
      asciinema
      awscli
      caddy2
      ccls
      chromedriver
      clang-tools
      crystal
      # dart
      editorconfig-core-c
      elixir
      elmPackages.elm
      elmPackages.elm-language-server
      erlang
      exercism
      fd
      # flutter
      gdb
      gitAndTools.git-hub
      ghc
      glib
      # gnome3.glade
      gobject-introspection
      # inotify-tools
      ix
      kubectl
      litecli
      lld_10
      lua
      minikube
      nasm
      nim
      openmpi
      # playerctl
      protobuf
      pkg-config
      redis
      ruby
      sass
      shellcheck
      shfmt
      # tinygo
      texlive.combined.scheme-basic
      wakatime
      # wasilibc
      openjdk8
      # zig

      # nix stuff
      comma
      nix-index
      nix-prefetch-github
      nixpkgs-review
      nixfmt
      patchelf

      # documents
      # gimp
      # gimp-with-plugins (broken)
      graphviz
      # libreoffice-fresh
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
      # discord
      slack
      # tdesktop
      # teams
      # zoom-us

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
      # insomnia
      miniserve
      netcat
      rclone
      telnet
      transmission-gtk

      # synchronization
      borgbackup
      # syncthing-gtk

      # entertainment
      epr
      youtube-dl

      # my stuff
      # swaylayout
      translate-shell
      blender
    ] ++ myNodePackages;
}

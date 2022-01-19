{ pkgs, ... }:

{
  home.packages = with pkgs;
    let
      comma = (import (builtins.fetchTarball {
        url = "https://github.com/Shopify/comma/archive/master.tar.gz";
        sha256 = "0n5a3rnv9qnnsrl76kpi6dmaxmwj1mpdd2g0b4n1wfimqfaz6gi1";
      }) { });
      myTexlive = (texlive.combine {
        inherit (texlive)
          scheme-basic etoolbox fontawesome microtype siunitx xcolor;
      });
    in [
      # development
      asciinema
      awscli
      cachix
      caddy
      cmake
      editorconfig-core-c
      elixir
      erlang
      exercism
      gawk
      gdb
      gitAndTools.git-hub
      gobject-introspection
      imagemagick
      jq
      kubectl
      lua
      luaPackages.lua-lsp
      minikube
      myTexlive
      nasm
      openmpi
      plantuml
      redis
      rnix-lsp
      sass
      unrar
      unzip

      # nix stuff
      # comma
      nixfmt
      nix-prefetch-github
      nixpkgs-fmt
      nixpkgs-review
      patchelf

      # documents
      graphviz
      pandoc

      # other ART (Awesome Rust Tools)
      fd
      hexyl
      hyperfine
      pastel
      tealdeer
      tokei

      # communication
      isync
      mu
      protonmail-bridge
      tmate

      # monitoring
      neofetch
      gotop
      speedtest-cli

      # passwords & security
      openssl
      pinentry

      # net & cloud tools
      ddgr
      doctl
      httpie
      netcat
      rclone
      telnet

      # entertainment
      aria2
      chatterino2
      mpv
      # portaudio
      # spotifyd
      streamlink
      youtube-dl

      # my stuff
      ical2org
      termdown
      translate-shell
    ];
}

{ pkgs, ... }:

{
  home.packages = with pkgs;
    let
      comma = (import
        (builtins.fetchTarball {
          url = "https://github.com/Shopify/comma/archive/master.tar.gz";
          sha256 = "0n5a3rnv9qnnsrl76kpi6dmaxmwj1mpdd2g0b4n1wfimqfaz6gi1";
        })
        { });
      myTexlive = (texlive.combine {
        inherit (texlive)
          capt-of
          cyrillic
          scheme-basic
          etoolbox
          fontawesome
          metafont
          microtype
          nopageno
          siunitx
          ulem
          wrapfig
          xcolor;
      });
    in
    [
      # development
      asciinema
      awscli2
      cachix
      caddy
      cmake
      editorconfig-core-c
      elixir
      erlang
      exercism
      gawk
      # gitAndTools.git-hub
      gobject-introspection
      # imagemagick
      jq
      kubectl
      lua
      luaPackages.lua-lsp
      minikube
      myTexlive
      nasm
      openmpi
      plantuml
      pre-commit
      p7zip
      redis
      # sass
      tokei
      unrar
      unzip

      # nix stuff
      # comma
      nix-prefetch-github
      nixpkgs-fmt
      nixpkgs-review
      patchelf

      # documents
      graphviz
      pandoc

      # communication
      isync
      mu
      tmate

      # monitoring
      neofetch
      speedtest-cli

      # passwords & security
      openssl

      # net & cloud tools
      aria2
      ddgr
      doctl
      # httpie
      netcat
      rclone
      inetutils

      # entertainment
      # chatterino2
      mpv
      # portaudio
      # spotifyd
      streamlink
      yt-dlp

      # other
      fd
      ffmpeg
      # gimp
      hexyl
      hyperfine
      my.ical2org
      # obs-studio
      pastel
      pngpaste
      tealdeer
      termdown
      translate-shell
    ];
}

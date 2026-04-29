{ lib, pkgs }:

with pkgs;
stdenv.mkDerivation rec {
  pname = "Menu";
  version = "0.0.5";

  phases = ["installPhase"];
  installPhase = ''
    install -D $src $out/bin/Menu
    chmod a+x $out/bin/Menu
  '';

  src = fetchurl {
    name = "Menu-${version}";
    url =
      "https://github.com/yshym/Menu/releases/download/v${version}/Menu";
    sha256 = "sha256-xEgCqnTtppFo9sb1UAmp/2Mvi2rAMBRt/Ko7felKLF0=";
  };

  meta = with lib; {
    description = "Lightweight macOS menu tool with app launcher mode and prerendering support";
    homepage = "https://github.com/yshym/Menu";
    platforms = platforms.darwin;
  };
}

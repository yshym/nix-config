{ lib, pkgs }:

with pkgs;
stdenv.mkDerivation rec {
  pname = "Menu";
  version = "0.0.3";

  phases = ["installPhase"];
  installPhase = ''
    install -D $src $out/bin/Menu
    chmod a+x $out/bin/Menu
  '';

  src = fetchurl {
    name = "Menu-${version}";
    url =
      "https://github.com/yshym/Menu/releases/download/v${version}/Menu";
    sha256 = "sha256-3HL0eZKX1C4i/xPCBdR1/mmNx72xF8YwAdYFJ2U6POQ=";
  };

  meta = with lib; {
    description = "Lightweight macOS menu tool with app launcher mode and prerendering support";
    homepage = "https://github.com/yshym/Menu";
    platforms = platforms.darwin;
  };
}

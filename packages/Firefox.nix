{ lib, stdenv, fetchurl, undmg }:

stdenv.mkDerivation rec {
  pname = "Firefox";
  version = "103.0";

  buildInputs = [ undmg ];
  sourceRoot = ".";
  phases = [ "unpackPhase" "installPhase" ];
  installPhase = ''
    mkdir -p "$out/Applications"
    cp -r Firefox.app "$out/Applications/Firefox.app"
  '';

  src = fetchurl {
    name = "Firefox-${version}.dmg";
    url =
      "https://download-installer.cdn.mozilla.net/pub/firefox/releases/${version}/mac/en-GB/Firefox%20${version}.dmg";
    sha256 = "sha256-zknqHyn1PivhsD0siUOQ9+z/5OOUKZZ5HCBfPNzBePE=";
  };

  meta = with lib; {
    description = "The Firefox web browser";
    homepage = "https://www.mozilla.org/en-GB/firefox";
    platforms = platforms.darwin;
  };
}

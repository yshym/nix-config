{ lib, stdenv, fetchurl, undmg }:

stdenv.mkDerivation rec {
  pname = "Brave";
  version = "1.25.68";

  buildInputs = [ undmg ];
  sourceRoot = ".";
  phases = [ "unpackPhase" "installPhase" ];
  installPhase = ''
    mkdir -p "$out/Applications"
    cp -r Brave\ Browser.app "$out/Applications/Brave.app"
  '';

  src = fetchurl {
    name = "Brave-${version}.dmg";
    url =
      "https://github.com/brave/brave-browser/releases/download/v${version}/Brave-Browser-x64.dmg";
    sha256 = "0vj6i76lp290qvvj0j8k0fgz34aqw46yp9rhb65wzakafgswpgix";
  };

  meta = with lib; {
    description = "Privacy-oriented browser for Desktop and Laptop computers";
    homepage = "https://brave.com/";
    platforms = platforms.darwin;
  };
}

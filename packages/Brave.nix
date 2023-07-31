{ lib, pkgs }:

with pkgs;
stdenv.mkDerivation rec {
  pname = "Brave";
  version = "1.53.31";

  buildInputs = [ undmg ];
  sourceRoot = ".";
  phases = [ "unpackPhase" "installPhase" ];
  installPhase = ''
    mkdir -p "$out/Applications"
    cp -r Brave\ Browser\ Nightly.app $out/Applications/Brave\ Browser.app
  '';

  src = fetchurl {
    name = "Brave-${version}.dmg";
    url =
      "https://github.com/brave/brave-browser/releases/download/v${version}/Brave-Browser-Nightly-universal.dmg";
    sha256 = "sha256-EKjW/EpSntVFnQJ/x2yM5+VmjSZ8Nc3p8wavtBes+qE=";
  };

  meta = with lib; {
    description = "Privacy-oriented browser for Desktop and Laptop computers";
    homepage = "https://brave.com/";
    platforms = platforms.darwin;
  };
}

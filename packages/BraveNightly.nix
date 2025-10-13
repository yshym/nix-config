{ lib, pkgs }:

with pkgs;
stdenv.mkDerivation rec {
  pname = "Brave Nightly";
  version = "1.85.27";

  sourceRoot = ".";
  unpackPhase = ''
    ${undmgLzma}/bin/undmg $src
  '';
  installPhase = ''
    mkdir -p "$out/Applications"
    cp -r Brave\ Browser\ Nightly.app $out/Applications/Brave\ Browser\ Nightly.app
  '';

  src = fetchurl {
    name = "Brave-Nightly-${version}.dmg";
    url =
      "https://github.com/brave/brave-browser/releases/download/v${version}/Brave-Browser-Nightly-universal.dmg";
    sha256 = "sha256-2GnmVVWyuTaD/ue6aY54xTqaHyK09bt3jPFl9eqwP6c=";
  };

  meta = with lib; {
    description = "Privacy-oriented browser for Desktop and Laptop computers";
    homepage = "https://brave.com/";
    platforms = platforms.darwin;
  };
}

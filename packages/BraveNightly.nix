{ lib, pkgs }:

with pkgs;
stdenv.mkDerivation rec {
  pname = "Brave Nightly";
  version = "1.86.63";

  buildInputs = [ undmg ];
  sourceRoot = ".";
  installPhase = ''
    mkdir -p "$out/Applications"
    cp -r Brave\ Browser\ Nightly.app $out/Applications/Brave\ Browser\ Nightly.app
  '';

  src = fetchurl {
    name = "Brave-Nightly-${version}.dmg";
    url =
      "https://github.com/brave/brave-browser/releases/download/v${version}/Brave-Browser-Nightly-universal.dmg";
    sha256 = "sha256-01QOsR7qUogmHAO/1QzIoMH2+B1zvDhcy2M1q2/R84Y=";
  };

  meta = with lib; {
    description = "Privacy-oriented browser for Desktop and Laptop computers";
    homepage = "https://brave.com/";
    platforms = platforms.darwin;
  };
}

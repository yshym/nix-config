{ lib, pkgs }:

with pkgs;
stdenv.mkDerivation rec {
  pname = "Brave";
  version = "1.26.74";

  buildInputs = [ undmg ];
  sourceRoot = ".";
  phases = [ "unpackPhase" "installPhase" ];
  installPhase = ''
    mkdir -p "$out/Applications"
    cp -r Brave\ Browser.app $out/Applications/Brave\ Browser.app
  '';

  src = fetchurl {
    name = "Brave-${version}.dmg";
    url =
      "https://github.com/brave/brave-browser/releases/download/v${version}/Brave-Browser-x64.dmg";
    sha256 = "18crc2m6b1hp3fc86g4n78f8xx76cpqmgdfggvd1s4hhmln8qbvi";
  };

  meta = with lib; {
    description = "Privacy-oriented browser for Desktop and Laptop computers";
    homepage = "https://brave.com/";
    platforms = platforms.darwin;
  };
}

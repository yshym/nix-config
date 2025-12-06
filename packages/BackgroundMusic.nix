{ lib, pkgs }:

with pkgs;
stdenv.mkDerivation rec {
  pname = "BackgroundMusic";
  version = "0.4.3";

  sourceRoot = ".";
  installPhase = ''
    mkdir -p "$out/Applications"
    cp -r BackgrounMusic.app $out/Applications/BackgroundMusic.app
  '';

  src = fetchurl {
    name = "Brave-${version}.dmg";
    url =
      "https://github.com/brave/brave-browser/releases/download/v${version}/BackgroundMusic.pkg";
    sha256 = "";
  };

  meta = with lib; {
    description = "MacOS audio utility";
    homepage = "https://github.com/kyleneideck/BackgroundMusic";
    platforms = platforms.darwin;
  };
}

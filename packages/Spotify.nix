{ lib, stdenv, fetchurl, undmg }:

stdenv.mkDerivation rec {
  pname = "Spotify";
  version = "latest";

  src = fetchurl {
    name = "Spotify-${version}.dmg";
    url = "http://download.spotify.com/Spotify.dmg";
    sha256 = "sha256-L+lMCWlKh7MSk2xeu55f4tcRjY/p5oJmhYatUuQufc4=";
  };

  buildInputs = [ undmg ];
  sourceRoot = ".";
  phases = [ "unpackPhase" "installPhase" ];
  installPhase = ''
    mkdir -p "$out/Applications"
    cp -r Spotify.app "$out/Applications/Spotify.app"
  '';

  meta = with lib; {
    description = "Play music from the Spotify music service";
    homepage = "https://www.spotify.com/";
    platforms = platforms.darwin;
  };
}

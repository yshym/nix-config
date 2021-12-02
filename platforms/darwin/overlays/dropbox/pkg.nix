{ lib, stdenv, fetchurl, undmg }:

stdenv.mkDerivation rec {
  pname = "Dropbox";
  version = "135.4.4221";

  buildInputs = [ undmg ];
  sourceRoot = ".";
  phases = [ "unpackPhase" "installPhase" ];
  installPhase = ''
    mkdir -p "$out/Applications"
    cp -r Dropbox.app "$out/Applications/Dropbox.app"
  '';

  src = fetchurl {
    name = "Dropbox-${version}.dmg";
    url = "https://www.dropbox.com/download?build=${version}&plat=mac&full=1";
    sha256 = "sha256-4NRKBBgSpzvnnLC+F69oF6zx73d/wBQKoseh2t5jeGI=";
  };

  meta = with lib; {
    description = "The Dropbox cloud storage";
    homepage = "https://www.dropbox.com";
    platforms = platforms.darwin;
  };
}

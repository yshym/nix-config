{ lib, stdenv, fetchurl, undmg }:

stdenv.mkDerivation rec {
  pname = "Dropbox";
  version = "latest";

  buildInputs = [ undmg ];
  sourceRoot = ".";
  phases = [ "unpackPhase" "installPhase" ];
  installPhase = ''
    mkdir -p "$out/Applications"
    cp -r Dropbox.app "$out/Applications/Dropbox.app"
  '';

  src = fetchurl {
    name = "Dropbox-${version}.dmg";
    url = "https://www.dropbox.com/download?plat=mac&full=1";
    sha256 = "sha256-jlpwYjV5ZN61NStoqsHn0ecjmOWljBS8x96pqbsaaoU=";
  };

  meta = with lib; {
    description = "The Dropbox cloud storage";
    homepage = "https://www.dropbox.com";
    platforms = platforms.darwin;
  };
}

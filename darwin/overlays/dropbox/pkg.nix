{ lib, stdenv, fetchurl, undmg }:

stdenv.mkDerivation rec {
  pname = "Dropbox";
  version = "111.0.0";

  buildInputs = [ undmg ];
  sourceRoot = ".";
  phases = [ "unpackPhase" "installPhase" ];
  unpackPhase = ''
    undmg ${src}
  '';
  installPhase = ''
    mkdir -p "$out/Applications"
    cp -r Dropbox.app "$out/Applications/Dropbox.app"
  '';

  src = fetchurl {
    name = "Dropbox-${version}.dmg";
    url = "https://www.dropbox.com/downloading";
    sha256 = "0cp85hqsnld6dn0hqg8k9k7n6lvfi88hzdr404plca3fgpciicdp";
  };

  meta = with lib; {
    description = "The Dropbox cloud storage";
    homepage = "https://www.dropbox.com";
    platforms = platforms.darwin;
  };
}

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
    sha256 = "15r0lcs7p4n5q67nq623rrhlqafan525xsz56ncndfib7fxqgj9g";
  };

  meta = with lib; {
    description = "The Dropbox cloud storage";
    homepage = "https://www.dropbox.com";
    platforms = platforms.darwin;
  };
}

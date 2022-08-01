{ lib, stdenv, fetchurl, undmg }:

stdenv.mkDerivation rec {
  pname = "Dropbox";
  version = "153.4.3932";

  buildInputs = [ undmg ];
  sourceRoot = ".";
  phases = [ "unpackPhase" "installPhase" ];
  installPhase = ''
    mkdir -p "$out/Applications"
    cp -r Dropbox.app "$out/Applications/Dropbox.app"
  '';

  src = fetchurl {
    name = "Dropbox-${version}.dmg";
    url = "https://www.dropbox.com/download?build=${version}&plat=mac&full=1${lib.optionalString (stdenv.system == "aarch64-darwin") "&arch=arm64"}";
    sha256 = "sha256-bCw0r9m6yNScHclVeNu4KKK/2Dj6b8Mb7BYZGtkeHsg=";
  };

  meta = with lib; {
    description = "The Dropbox cloud storage";
    homepage = "https://www.dropbox.com";
    platforms = platforms.darwin;
  };
}

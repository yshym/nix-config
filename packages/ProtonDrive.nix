{ lib, stdenv, fetchurl, undmg }:

stdenv.mkDerivation rec {
  pname = "ProtonDrive";
  version = "1.0.1";

  buildInputs = [ undmg ];
  sourceRoot = ".";
  phases = [ "unpackPhase" "installPhase" ];
  installPhase = ''
    mkdir -p "$out/Applications"
    cp -r Dropbox.app "$out/Applications/Dropbox.app"
  '';

  src = fetchurl {
    name = "ProtonDrive-${version}.dmg";
    url = "https://proton.me/download/drive/macos/ProtonDrive-${version}.dmg";
    sha256 = "sha256-OtlYcvx9RbLi/Y5To2FLHOMkp4rSaaUuQA1cAuPgetM=";
  };

  meta = with lib; {
    description = "Encrypted cloud storage and file sharing";
    homepage = "https://www.dropbox.com";
    platforms = platforms.darwin;
  };
}

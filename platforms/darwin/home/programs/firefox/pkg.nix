{ lib, stdenv, fetchurl, undmg }:

stdenv.mkDerivation rec {
  pname = "Firefox";
  version = "91.0.2";

  buildInputs = [ undmg ];
  sourceRoot = ".";
  phases = [ "unpackPhase" "installPhase" ];
  installPhase = ''
    mkdir -p "$out/Applications"
    cp -r Firefox.app "$out/Applications/Firefox.app"
  '';

  src = fetchurl {
    name = "Firefox-${version}.dmg";
    url =
      "https://download-installer.cdn.mozilla.net/pub/firefox/releases/${version}/mac/en-GB/Firefox%20${version}.dmg";
    sha256 = "0rs04n5id2njqna4bvylal548ilnrdb45f7cy6nrwvfjkg715lg8";
  };

  meta = with lib; {
    description = "The Firefox web browser";
    homepage = "https://www.mozilla.org/en-GB/firefox";
    platforms = platforms.darwin;
  };
}

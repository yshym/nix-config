{ lib, stdenv, fetchurl, undmg }:

stdenv.mkDerivation rec {
  pname = "FirefoxDev";
  version = "120.0b9";

  buildInputs = [ undmg ];
  sourceRoot = ".";
  phases = [ "unpackPhase" "installPhase" ];
  installPhase = ''
    mkdir -p "$out/Applications"
    cp -r Firefox\ Developer\ Edition.app "$out/Applications/FirefoxDev.app"
  '';

  src = fetchurl {
    name = "FirefoxDev-${version}.dmg";
    url =
      "https://download-installer.cdn.mozilla.net/pub/devedition/releases/${version}/mac/en-GB/Firefox%20${version}.dmg";
    sha256 = "sha256-Nf5FphzD909gB5b7KjI7Tb8r2kh5DvdoQklhlKeKEDo=";
  };

  meta = with lib; {
    description = "The Firefox Devloper Edition web browser";
    homepage = "https://www.mozilla.org/en-GB/firefox/developer";
    platforms = platforms.darwin;
  };
}

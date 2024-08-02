{ lib, pkgs }:

with pkgs;
stdenv.mkDerivation rec {
  pname = "Gitify";
  version = "5.9.0";

  sourceRoot = ".";
  unpackPhase = ''
    ${_7zz}/bin/7zz x $src
  '';
  installPhase = ''
    mkdir -p "$out/Applications"
    cp -r Gitify.app $out/Applications/Gitify.app
  '';

  src = fetchurl {
    name = "Gitify-${version}.dmg";
    url =
      "https://github.com/gitify-app/gitify/releases/download/v${version}/Gitify-${version}-universal.dmg";
    sha256 = "sha256-mqBGcFzfSBF6FrLzFqHI7CMBYF1JTNUoatCt6Wnb/Xw=";
  };

  meta = with lib; {
    description = "Privacy-oriented browser for Desktop and Laptop computers";
    homepage = "https://brave.com/";
    platforms = platforms.darwin;
  };
}

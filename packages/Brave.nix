{ lib, pkgs }:

with pkgs;
stdenv.mkDerivation rec {
  pname = "Brave";
  version = "1.81.137";

  sourceRoot = ".";
  unpackPhase = ''
    ${undmgLzma}/bin/undmg $src
  '';
  installPhase = ''
    mkdir -p "$out/Applications"
    cp -r Brave\ Browser.app $out/Applications/Brave\ Browser.app
  '';

  src = fetchurl {
    name = "Brave-${version}.dmg";
    url =
      "https://github.com/brave/brave-browser/releases/download/v${version}/Brave-Browser-universal.dmg";
    sha256 = "sha256-fwRJixwl9hDbV9U/f6bfjoj1GF4SOOdaO9UT6Op/mqc=";
  };

  meta = with lib; {
    description = "Privacy-oriented browser for Desktop and Laptop computers";
    homepage = "https://brave.com/";
    platforms = platforms.darwin;
  };
}

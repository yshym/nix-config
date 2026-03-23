{ lib, stdenv, apple-sdk_26 }:

stdenv.mkDerivation {
  pname = "Menu";
  version = "0.3.0";
  src = ./.;

  buildInputs = [ apple-sdk_26 ];

  installPhase = ''
    mkdir -p $out/bin
    cp Menu $out/bin/
  '';

  meta = {
    description = "Lightweight macOS menu tool with app launcher mode";
    platforms = lib.platforms.darwin;
  };
}

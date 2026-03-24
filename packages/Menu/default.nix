{ lib, stdenv, apple-sdk, swift }:

stdenv.mkDerivation {
  pname = "Menu";
  version = "0.4.0";
  src = ./.;

  nativeBuildInputs = [ swift ];
  buildInputs = [ apple-sdk ];

  installPhase = ''
    mkdir -p $out/bin
    cp Menu $out/bin/
  '';

  meta = {
    description = "Lightweight macOS menu tool with app launcher mode";
    platforms = lib.platforms.darwin;
  };
}

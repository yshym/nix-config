{ lib, stdenv, fetchurl, undmg }:

stdenv.mkDerivation rec {
  pname = "Telegram";
  version = "6.1.0";

  buildInputs = [ undmg ];
  sourceRoot = ".";
  phases = [ "unpackPhase" "installPhase" ];
  installPhase = ''
    mkdir -p "$out/Applications"
    cp -r Telegram.app "$out/Applications/Telegram.app"
  '';

  src = fetchurl {
    name = "Telegram-${version}.dmg";
    url =
      "https://github.com/telegramdesktop/tdesktop/releases/download/v${version}/tsetup.${version}.dmg";
    sha256 = "sha256-yrOnKbzypcfxXvZzWYE8bx7nDHWt03RPK0ujInx6MeA=";
  };

  meta = with lib; {
    description = "Telegram Desktop messaging app";
    homepage = "https://desktop.telegram.org";
    platforms = platforms.darwin;
  };
}

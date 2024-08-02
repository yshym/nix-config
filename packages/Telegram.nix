{ lib, stdenv, fetchurl, undmg }:

stdenv.mkDerivation rec {
  pname = "Telegram";
  version = "5.1.7";

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
    sha256 = "sha256-aJzKZp6ZM7f2xrHsQiQkulrCh0iIlXlcIDDAknZSWF0=";
  };

  meta = with lib; {
    description = "Telegram Desktop messaging app";
    homepage = "https://desktop.telegram.org";
    platforms = platforms.darwin;
  };
}

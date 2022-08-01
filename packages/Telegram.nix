{ lib, stdenv, fetchurl, undmg }:

stdenv.mkDerivation rec {
  pname = "Telegram";
  version = "4.0.2";

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
    sha256 = "sha256-Jr0jP15TQOJwWmo8Rbn2fGWMvMoSQTQ+Tl9e4HgFjBc=";
  };

  meta = with lib; {
    description = "Telegram Desktop messaging app";
    homepage = "https://desktop.telegram.org";
    platforms = platforms.darwin;
  };
}

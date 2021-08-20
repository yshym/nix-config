{ lib, stdenv, fetchurl, undmg }:

stdenv.mkDerivation rec {
  pname = "Telegram";
  version = "2.9.3";

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
    sha256 = "1nv1cgqrjjmw5dppks8whzxb98mdpv4nzdis3qyv5z15ac8ljfgy";
  };

  meta = with lib; {
    description = "Telegram Desktop messaging app";
    homepage = "https://desktop.telegram.org";
    platforms = platforms.darwin;
  };
}

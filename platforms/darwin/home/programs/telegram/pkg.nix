{ lib, stdenv, fetchurl, undmg }:

stdenv.mkDerivation rec {
  pname = "Telegram";
  version = "3.1.0";

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
    sha256 = "sha256-vUudcGiw4UTjdrX4tD7y5+D3LH+fW6eAoq9r09kJPe4=";
  };

  meta = with lib; {
    description = "Telegram Desktop messaging app";
    homepage = "https://desktop.telegram.org";
    platforms = platforms.darwin;
  };
}

{ lib, pkgs }:

with pkgs;
stdenv.mkDerivation rec {
  pname = "Telegram";
  version = "7.3.3";

  buildInputs = [ undmg ];
  sourceRoot = ".";
  installPhase = ''
    mkdir -p "$out/Applications"
    cp -r Telegram.app "$out/Applications/Telegram.app"
  '';

  src = fetchurl {
    name = "Telegram-${version}.dmg";
    url =
      "https://github.com/telegramdesktop/tdesktop/releases/download/v${version}/td-setup-mac-${version}.dmg";
    sha256 = "sha256-L2Gse4q10RkKmrCqIxmEaLy96esmxjr0cIFh7WpffNM=";
  };

  meta = with lib; {
    description = "Telegram Desktop messaging app";
    homepage = "https://desktop.telegram.org";
    platforms = platforms.darwin;
  };
}

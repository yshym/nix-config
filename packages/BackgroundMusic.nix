{ lib, pkgs }:

with pkgs;
stdenv.mkDerivation rec {
  pname = "BackgroundMusic";
  version = "0.4.3";

  nativeBuildInputs = [
    cpio
    xar
  ];

  unpackPhase = ''
    runHook preUnpack

    xar -xf $src
    zcat Installer.pkg/Payload | cpio -i

    runHook postUnpack
  '';

  src = fetchurl {
    name = "BackgroundMusic-${version}.pkg";
    url =
      "https://github.com/kyleneideck/BackgroundMusic/releases/download/v${version}/BackgroundMusic-${version}.pkg";
    sha256 = "sha256-wcSKN8g69EzlC+5oh5hWyWsvbJc2DORhscfWU1Fb5/0=";
  };

  installPhase = ''
    mkdir -p "$out/Library/Audio/Plug-Ins/HAL"
    mkdir -p "$out/Applications"
    cp -r Library/Audio/Plug-Ins/HAL/Background\ Music\ Device.driver $out/Library/Audio/Plug-Ins/HAL/Background\ Music\ Device.driver
    cp -r Applications/Background\ Music.app $out/Applications/Background\ Music.app
  '';

  meta = with lib; {
    description = "MacOS audio utility";
    homepage = "https://github.com/kyleneideck/BackgroundMusic";
    platforms = platforms.darwin;
  };
}

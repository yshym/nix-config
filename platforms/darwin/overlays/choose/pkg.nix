{ lib, stdenv, fetchFromGitHub, AppKit, Cocoa, xcbuildHook }:

stdenv.mkDerivation rec {
  pname = "choose";
  version = "1.2";

  nativeBuildInputs = [ xcbuildHook ];
  buildInputs = [ AppKit Cocoa ];
  xcbuildFlags = [ "-configuration" "Release" ];
  installPhase = ''
    mkdir -p $out/bin
    install -m755 Products/Release/choose $out/bin/choose
  '';

  src = fetchFromGitHub {
    owner = "yevhenshymotiuk";
    repo = pname;
    rev = version;
    sha256 = "sha256-tCQZ94OQtC6qs2JM/BIX4boLYeHVn6zwpR5cOFV9o5Y=";
  };

  meta = with lib; {
    description =
      "Fuzzy matcher for OS X that uses both std{in,out} and a native GUI.";
    homepage = "https://github.com/chipsenkbeil/choose";
    platforms = platforms.darwin;
  };
}

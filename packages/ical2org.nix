{ lib, stdenv, fetchFromGitHub, gawk, ... }:

stdenv.mkDerivation rec {
  pname = "ical2org";
  version = "a68bc938469b5880f75bf59fcc098974f5b07ecd";

  src = fetchFromGitHub {
    owner = "yshym";
    repo = "ical2org";
    rev = version;
    sha256 = "sha256-UWvkWcu7SwO60FLMaB3SXpw7WIGArCdkS8QCV1Q4Z8Y=";
  };

  nativeBuildInputs = [ gawk ];

  installPhase = ''
    mkdir -p "$out/bin"
    install -m755 ical2org.awk "$out/bin/ical2org"
    substituteInPlace "$out/bin/ical2org" \
      --replace "/usr/bin/env -S gawk -f" "${gawk}/bin/gawk -f"
  '';

  meta = with lib; {
    description = "Convert ics files to org mode";
    homepage = "https://github.com/yshym/ical2org";
    platforms = platforms.all;
  };
}

{ lib, stdenv, fetchFromGitHub, gawk, ... }:

stdenv.mkDerivation rec {
  pname = "ical2org";
  version = "d18cd3b072a19751df4265fd0427cfe1d1b9f874";

  src = fetchFromGitHub {
    owner = "yshym";
    repo = "ical2org";
    rev = version;
    sha256 = "sha256-NxV2ipwHm4pq6ZbSKiG3MXGugRqSnoeizdsVqtS4sqw=";
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

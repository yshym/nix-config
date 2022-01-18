{ lib, buildPythonPackage, stdenv, fetchPypi, pythonOlder, colorama, toml
, watchdog }:

buildPythonPackage rec {
  pname = "sortdir";
  version = "0.2.2";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-uEyB6v6y/lSRo2j+7bTRciMlw1Z7H6gayRKSuvEM4sA=";
  };

  propagatedBuildInputs = [ colorama toml watchdog ];

  meta = with lib; {
    description = "Sorting directory files made easy.";
    homepage = "https://github.com/yevhenshymotiuk/sortdir";
    platforms = platforms.all;
    # watchdog is broken on x86_64-darwin
    broken = stdenv.isDarwin && !stdenv.isAarch64;
  };
}

{ lib, stdenv, fetchPypi, pythonOlder, watchdog }:

stdenv.mkDerivation rec {
  pname = "sortdir";
  version = "0.1.0";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0000000000000000000000000000000000000000000000000000";
  };

  propagatedBuildInputs = [ watchdog ];

  meta = with lib; {
    description = "Sorting directory files made easy.";
    homepage = "https://github.com/yevhenshymotiuk/sortdir";
    platforms = platforms.all;
  };
}

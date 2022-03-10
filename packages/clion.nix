{ lib, pkgs }:

with pkgs.python3Packages;
buildPythonPackage rec {
  pname = "clion";
  version = "0.3.2";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-kSHzny3wjcpcmbZS1sw0NPFC1JYlgNHCgbs+khd0naw=";
  };

  meta = with lib; {
    description = "Minimalistic library for building CLI applications.";
    homepage = "https://github.com/yshym/clion";
    platforms = platforms.all;
  };
}

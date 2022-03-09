{ lib, pkgs }:

with pkgs.python3Packages;
buildPythonPackage rec {
  pname = "clion";
  version = "0.3.1";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-xBJhW7RWn6ZuZsGgFJDhx6r9i99O7DtBvqv4pUxXZZk=";
  };

  meta = with lib; {
    description = "Minimalistic library for building CLI applications.";
    homepage = "https://github.com/yshym/clion";
    platforms = platforms.all;
  };
}

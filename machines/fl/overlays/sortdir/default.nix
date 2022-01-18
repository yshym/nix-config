self: super:

{
  sortdir = super.callPackage ./pkg.nix (with super.python3Packages; {
    inherit buildPythonPackage fetchPypi pythonOlder colorama toml watchdog;
  });
}

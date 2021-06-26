self: super:

{
  sortdir = super.callPackage ./pkg.nix (with super.python3Packages; {
    fetchPypi = fetchPypi;
    pythonOlder = pythonOlder;
    watchdog = watchdog;
  });
}

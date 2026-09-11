{ pkgs ? import <nixpkgs> {} }:

with pkgs;

mkShell {
  buildInputs = [
    janet
    jpm
  ];
  shellHook = ''
    export JANET_TREE=$PWD/jpm_tree
    export JANET_PATH=$JANET_TREE/lib
    export PATH=$JANET_TREE/bin:$PATH
  '';
}

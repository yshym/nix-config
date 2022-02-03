{ lib, pkgs, ... }:

with builtins;
with lib; {
  toCSSFile = file:
    let
      fileName = removeSuffix ".sass" (baseNameOf file);
      compiledStyles =
        pkgs.runCommand "compileSassFile" { buildInputs = [ pkgs.sass ]; } ''
          mkdir "$out"
          sass --sourcemap=none \
               --no-cache \
               --style compressed \
               --default-encoding utf-8 \
               "${file}" \
               "$out/${fileName}.css"
        '';
    in "${compiledStyles}/${fileName}.css";
}

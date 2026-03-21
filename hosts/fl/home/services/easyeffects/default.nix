{ ... }:

let
    inherit (builtins) readFile fromJSON;
in
{
  home.services.easyeffects = {
    enable = true;
    preset = "fw-13";
    extraPresets = {
      fw-13 = fromJSON (readFile ./fw-13.json);
    };
  };
}

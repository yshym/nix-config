{ ... }:

self: super:
{
  # NOTE Used to always keep yabai up-to-date
  yabai = super.yabai.overrideAttrs (o: rec {
    version = "7.1.10";
    src = builtins.fetchTarball {
      url =
        "https://github.com/koekeishiya/yabai/releases/download/v${version}/yabai-v${version}.tar.gz";
      sha256 = "1yags8amblfh6bdll3cirwi4xd7npdfg9y87l3ly5n7pdk4w1nwj";
    };

    installPhase = ''
      mkdir -p $out/bin
      mkdir -p $out/share/man/man1/
      cp ./bin/yabai $out/bin/yabai
      cp ./doc/yabai.1 $out/share/man/man1/yabai.1
    '';
  });
}

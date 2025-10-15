{ ... }:

self: super:
{
  # NOTE Used to always keep yabai up-to-date
  yabai = super.yabai.overrideAttrs (o: rec {
    version = "7.1.16";
    src = builtins.fetchTarball {
      url =
        "https://github.com/koekeishiya/yabai/releases/download/v${version}/yabai-v${version}.tar.gz";
      sha256 = "101djah9h1j935ygysh96zcflhc69vb9wb0nx5rwy7zw8xv80mhq";
    };

    installPhase = ''
      mkdir -p $out/bin
      mkdir -p $out/share/man/man1/
      cp ./bin/yabai $out/bin/yabai
      cp ./doc/yabai.1 $out/share/man/man1/yabai.1
    '';
  });
}

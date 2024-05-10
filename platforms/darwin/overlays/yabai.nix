{ ... }:

self: super:
{
  # NOTE Used to always keep yabai up-to-date
  yabai = super.yabai.overrideAttrs (o: rec {
    version = "7.1.0";
    src = builtins.fetchTarball {
      url =
        "https://github.com/koekeishiya/yabai/releases/download/v${version}/yabai-v${version}.tar.gz";
      sha256 = "0y34kklrsjgzp03v4dq0s7na7m9kvxfc7bzydz3idv7phj3a87i6";
    };

    installPhase = ''
      mkdir -p $out/bin
      mkdir -p $out/share/man/man1/
      cp ./bin/yabai $out/bin/yabai
      cp ./doc/yabai.1 $out/share/man/man1/yabai.1
    '';
  });
}

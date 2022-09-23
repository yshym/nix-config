{ ... }:

self: super:
{
  # NOTE Switch back to src build when issue is fixed
  yabai = super.yabai.overrideAttrs (o: rec {
    version = "5.0.0";
    src = builtins.fetchTarball {
      url =
        "https://github.com/koekeishiya/yabai/releases/download/v${version}/yabai-v${version}.tar.gz";
      sha256 = "1yhksdxnv7a5zblkq2s3mkxv3sprrdzhmxyhif54f3a4s91vpkkj";
    };

    installPhase = ''
      mkdir -p $out/bin
      mkdir -p $out/share/man/man1/
      cp ./bin/yabai $out/bin/yabai
      cp ./doc/yabai.1 $out/share/man/man1/yabai.1
    '';
  });
}

{ ... }:

self: super:
{
  # NOTE Switch back to src build when issue is fixed
  yabai = super.yabai.overrideAttrs (o: rec {
    version = "4.0.4";
    src = builtins.fetchTarball {
      url =
        "https://github.com/koekeishiya/yabai/releases/download/v${version}/yabai-v${version}.tar.gz";
      sha256 = "0rfg6kqhnsryclny5drj85h442kz5bc9rks60c3lz0a842yvi1c2";
    };

    installPhase = ''
      mkdir -p $out/bin
      mkdir -p $out/share/man/man1/
      cp ./bin/yabai $out/bin/yabai
      cp ./doc/yabai.1 $out/share/man/man1/yabai.1
    '';
  });
}

{ ... }:

self: super:
{
  # NOTE Used to always keep yabai up-to-date
  yabai = super.yabai.overrideAttrs (o: rec {
    version = "7.1.1";
    src = builtins.fetchTarball {
      url =
        "https://github.com/koekeishiya/yabai/releases/download/v${version}/yabai-v${version}.tar.gz";
      sha256 = "0l31zppaq0jhnra1z2ddpj5rw4sz9f04wyja3sizsaad5acd94aw";
    };

    installPhase = ''
      mkdir -p $out/bin
      mkdir -p $out/share/man/man1/
      cp ./bin/yabai $out/bin/yabai
      cp ./doc/yabai.1 $out/share/man/man1/yabai.1
    '';
  });
}

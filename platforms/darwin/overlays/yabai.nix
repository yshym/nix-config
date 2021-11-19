self: super:

{
  # TODO: Switch back to src build when issue is fixed
  yabai = super.yabai.overrideAttrs (o: rec {
    version = "4.0.0";
    src = builtins.fetchTarball {
      url =
        "https://github.com/koekeishiya/yabai/files/7570537/yabai-v4.0.0.tar.gz";
      sha256 = "1kpgnc2fwf45zrnw54vg1yfqvpg2m6w191lpvvhwsx6f5410b92y";
    };

    installPhase = ''
      mkdir -p $out/bin
      mkdir -p $out/share/man/man1/
      cp ./bin/yabai $out/bin/yabai
      cp ./doc/yabai.1 $out/share/man/man1/yabai.1
    '';
  });
}

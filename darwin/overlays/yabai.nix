self: super:

{
  # TODO: Switch back to src build when issue is fixed
  yabai = super.yabai.overrideAttrs (o: rec {
    version = "3.3.8";
    src = builtins.fetchTarball {
      url =
        "https://github.com/koekeishiya/yabai/releases/download/v${version}/yabai-v${version}.tar.gz";
      sha256 = "1b1xyyx3kvm9x81aarp5dx28nbd3m77z88m2yw6s6pd5myigc006";
    };

    installPhase = ''
      mkdir -p $out/bin
      mkdir -p $out/share/man/man1/
      cp ./archive/bin/yabai $out/bin/yabai
      cp ./archive/doc/yabai.1 $out/share/man/man1/yabai.1
    '';
  });
}

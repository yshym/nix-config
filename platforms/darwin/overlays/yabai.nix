self: super:

{
  # TODO: Switch back to src build when issue is fixed
  yabai = super.yabai.overrideAttrs (o: rec {
    version = "3.3.10";
    src = builtins.fetchTarball {
      url =
        "https://github.com/koekeishiya/yabai/releases/download/v${version}/yabai-v${version}.tar.gz";
      sha256 = "025ww9kjpy72in3mbn23pwzf3fvw0r11ijn1h5pjqvsdlak91h9i";
    };

    installPhase = ''
      mkdir -p $out/bin
      mkdir -p $out/share/man/man1/
      cp ./archive/bin/yabai $out/bin/yabai
      cp ./archive/doc/yabai.1 $out/share/man/man1/yabai.1
    '';
  });
}

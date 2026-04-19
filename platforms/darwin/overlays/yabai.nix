{ ... }:

self: super:
{
  # Used to always keep yabai up-to-date
  yabai = super.yabai.overrideAttrs (o: rec {
    version = "v7.1.22";

    src = super.fetchFromGitHub {
      owner = "koekeishiya";
      repo = "yabai";
      rev = version;
      sha256 = "sha256-T3sZhJpoZJKQhZpGDyEhpw+dMXoaFO9PEd0g0jDcihc=";
    };

    nativeBuildInputs = o.nativeBuildInputs ++ [ super.xxd ];

    buildInputs = [ super.apple-sdk_15 ];

    dontConfigure = false;
    dontBuild = false;
    enableParallelBuilding = false;

    # Strip x86_64 and arm64 cross-compilation flags, but keep arm64
    postPatch = ''
      substituteInPlace makefile \
      --replace-fail "-arch x86_64" "" \
      --replace-fail "-arch arm64 " ""
    '';

    nativeInstallCheckInputs = [ ];
  });
}

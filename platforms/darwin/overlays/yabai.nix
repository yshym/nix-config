{ ... }:

self: super:
{
  # Used to always keep yabai up-to-date
  yabai = super.yabai.overrideAttrs (o: rec {
    version = "54728ce89a134d3ff83b356b1f0b86fba50b90b5";

    src = super.fetchFromGitHub {
      owner = "koekeishiya";
      repo = "yabai";
      rev = version;
      sha256 = "sha256-IVVwlqMlkfkgqmZegVeVwt/YRSIfaH+swTWAikl64wY=";
    };

    nativeBuildInputs = o.nativeBuildInputs ++ [ super.xxd ];

    buildInputs = [ super.apple-sdk_15 ];

    dontConfigure = false;
    dontBuild = false;
    enableParallelBuilding = false;

    # Strip x86_64 and arm64e cross-compilation flags, but keep arm64
    postPatch = ''
      substituteInPlace makefile \
      --replace-fail "-arch x86_64" "" \
      --replace-fail "-arch arm64e" ""
    '';

    nativeInstallCheckInputs = [ ];
  });
}

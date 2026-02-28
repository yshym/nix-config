{ ... }:

self: super:
{
  # Used to always keep yabai up-to-date
  yabai = super.yabai.overrideAttrs (o: rec {
    version = "5bde933ec85a4a601a186163b7db04aa3bf6c3b1";

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

    # Strip x86_64 and arm64e cross-compilation flags, but keep arm64
    postPatch = ''
      substituteInPlace makefile \
      --replace-fail "-arch x86_64" "" \
      --replace-fail "-arch arm64e" ""
    '';

    nativeInstallCheckInputs = [ ];
  });
}

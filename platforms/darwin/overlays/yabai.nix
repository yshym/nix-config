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

    # Strip x86_64 cross-compilation flags — Nix's clang wrapper can't
    # cross-compile and lipo fails when both arches are requested.
    # Keep arm64 / arm64e for the native aarch64 build.
    postPatch = ''
      substituteInPlace makefile --replace-fail "-arch x86_64" ""
    '';

    nativeInstallCheckInputs = [ ];
  });
}

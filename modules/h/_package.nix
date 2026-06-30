{ stdenv, lib, fetchFromGitHub, nix-gitignore, janet, jpm, gcc }:

let
  posix-spawn = fetchFromGitHub {
    owner = "andrewchambers";
    repo = "janet-posix-spawn";
    rev = "3e68f493a6c3b8ed5c333750e33a11ea1a3d00f7";
    sha256 = "sha256-+Xr7Z0ETQi/ofLRBcTcGv6KtTk04V7/Chfg/IZNB7zY=";
  };
  janet-sh = fetchFromGitHub {
    owner = "andrewchambers";
    repo = "janet-sh";
    rev = "221bcc869bf998186d3c56a388c8313060bfd730";
    sha256 = "sha256-pqpEs/qfHe/e2ywSuqzWZhfw/YHZNkTsKHZHoaoVTc4=";
  };
  judge = fetchFromGitHub {
    owner = "ianthehenry";
    repo = "judge";
    rev = "v2.4.0";
    sha256 = "sha256-ef2ol4k36tRCDyOdvBXu38t2U3baMRBM4b+eWOikW7w=";
  };
in
stdenv.mkDerivation {
  pname = "h";
  version = "0.1.0";

  src = nix-gitignore.gitignoreSource [ ] ./.;

  nativeBuildInputs = [ janet jpm gcc ];

  buildPhase = ''
    runHook preBuild

    export JANET_TREE=$PWD/jpm_tree
    export JANET_PATH=$JANET_TREE/lib
    mkdir -p $JANET_TREE

    JPM="jpm --tree=$JANET_TREE \
      --headerpath=${janet}/include \
      --libpath=${janet}/lib"

    # Install third-party deps in dependency order.
    # Each dep is copied to a writable scratch dir so jpm can build natives.
    install_dep() {
      local src=$1 name=$2
      cp -r "$src" "$name"
      chmod -R u+w "$name"
      (cd "$name" && $JPM install)
    }

    install_dep ${posix-spawn} posix-spawn
    install_dep ${janet-sh}    janet-sh
    install_dep ${judge}       judge

    # Build our project (local cmd lib is imported via relative path).
    $JPM build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 build/h $out/bin/h
    runHook postInstall
  '';

  meta = {
    description = "Nix helper CLI";
    platforms = lib.platforms.unix;
  };
}

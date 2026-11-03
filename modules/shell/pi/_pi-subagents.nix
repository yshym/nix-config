{ lib, buildNpmPackage, fetchFromGitHub, ... }:

buildNpmPackage (rec {
  pname = "pi-subagents";
  version = "0.23.0";

  src = fetchFromGitHub {
    owner = "tintinweb";
    repo = "pi-subagents";
    rev = "v${version}";
    hash = "sha256-aJxGX+s08oNzVkmSVDmQwpqBjvY6yvMDNHIB7XKYH6U=";
  };

  # The package ships src/*.ts (loaded directly by pi via jiti) and a prebuilt
  # dist/, so there is no build step. We only need node_modules for the runtime
  # deps (croner, nanoid); @earendil-works/* and typebox are host-provided by pi.
  npmDepsHash = "sha256-BuyLyFIuaVuH7jBjt7p7FgcErzrO/2KwLcY7ZSMbJwU=";
  dontNpmBuild = true;

  # Don't run the package's own test/lint/prepublish scripts.
  npmFlags = [ "--ignore-scripts" ];

  meta = {
    description = "Claude Code-style sub-agents and workflow orchestration for pi";
    homepage = "https://github.com/tintinweb/pi-subagents";
    license = lib.licenses.mit;
  };
})

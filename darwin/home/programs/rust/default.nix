{ pkgs, ... }:

{
  home.packages = with pkgs; [
    cargo-asm
    cargo-audit
    cargo-bloat
    cargo-deps
    cargo-flamegraph
    cargo-graph
    cargo-inspect
    cargo-license
    cargo-outdated
    cargo-release
    cargo-sweep
    cargo-update
    cargo-web
    rustup
    wasm-pack
  ];

  programs.zsh.envExtra = ''
    export PATH="$HOME/.cargo/bin:$PATH"
  '';
}

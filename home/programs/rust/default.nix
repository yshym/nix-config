{ pkgs, ... }:

{
  home.packages = with pkgs; [
    cargo-asm
    cargo-audit
    cargo-bloat
    cargo-deb
    cargo-deps
    cargo-expand
    cargo-flamegraph
    cargo-geiger
    cargo-graph
    cargo-inspect
    cargo-license
    cargo-make
    cargo-outdated
    cargo-release
    cargo-sweep
    cargo-watch
    cargo-web
    rustup
    sccache
    wasm-pack
  ];

  programs.zsh.envExtra = ''
    export RUSTC_WRAPPER=sccache
    export PATH="$HOME/.cargo/bin:$PATH"
  '';
}

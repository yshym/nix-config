{ config, pkgs, ... }: {
  imports = [
    ./asdf.nix
    ./crystal.nix
    ./direnv
    ./doom
    ./git.nix
    ./nodejs.nix
    ./prettier
    ./python
    ./ranger
    ./ripgrep.nix
    ./ruby.nix
    ./rust
    ./scripts
    ./topgrade
    ./zsh
  ];

  programs = {
    crystal.enable = false;
    direnv.enable = true;
    doom.enable = true;
    emacs = { 
      enable = true;
      package = pkgs.emacsMacport;
    };
    git = {
      enable = true;
      pager = "diff-so-fancy";
    };
    go.enable = true;
    nodejs = {
      enable = true;
      yarn.enable = true;
    };
    python = {
      enable = true;
      extraPackages = with pkgs.python3Packages; [
        codecov
        grip
        poetry
      ];
      black.enable = true;
      mypy.enable = true;
      pipx.enable = true;
      pylint.enable = true;
    };
    topgrade = {
      enable = true;
      config = {
        disable = [ "emacs" "gem" ];
        gitRepos = [ "~/.emacs.d" ];
      };
    };
    ruby = {
      enable = false;
      enableBuildLibs = true;
      provider = "nixpkgs";
      enableSolargraph = true;
    };
    zsh.enable = true;
  };
}

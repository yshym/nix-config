{ ... }:

{
  home.file.".local/platform/bin" = {
    source = ./bin;
    recursive = true;
  };

  programs.zsh = {
    envExtra = ''
      export PATH="$HOME/.local/platform/bin:$PATH"
    '';
  };
}

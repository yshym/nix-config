{ ... }:

{
  home.file.".local/bin" = {
    source = ./bin;
    recursive = true;
  };

  programs.zsh = {
    envExtra = ''
      export PATH="$HOME/.local/bin:$PATH"
    '';
  };
}

{ config, lib, pkgs, ... }:

let cfg = config.programs.neovim; in
{
  programs.neovim = {
    enable = true;
    withPython3 = true;
    plugins = with pkgs.vimPlugins; [
      lualine-nvim
      rose-pine
      supertab
      vim-airline-themes
      vim-nix
    ];
    extraConfig = ''
      set number                    " Enable line numbers by default
      set background=dark           " Set the default background to dark or light
      set smartindent               " Automatically insert extra level of indentation
      set tabstop=4                 " Default tabstop
      set shiftwidth=4              " Default indent spacing
      set expandtab                 " Expand [TABS] to spaces
      syntax enable                 " Enable syntax highlighting
      colorscheme rose-pine         " Set the default colour scheme
      set t_Co=256                  " use 265 colors in vim
      set spell spelllang=en_au     " Default spell checking language
      hi clear SpellBad             " Clear any unwanted default settings
      hi SpellBad cterm=underline   " Set the spell checking highlight style
      hi SpellBad ctermbg=NONE      " Set the spell checking highlight background
      match ErrorMsg '\s\+$'        "

      set laststatus=2   " Set up the status line so it's coloured and always on
      inoremap fd <Esc>
    '';
  };

  programs.zsh.shellAliases.vim = lib.mkIf cfg.enable "nvim";
}

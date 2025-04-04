{ config, lib, pkgs, ... }:

with pkgs; {
  programs.alacritty = {
    enable = true;
    package = pkgs.unstable.alacritty;
    settings = {
      window = {
        decorations = if stdenv.isDarwin then "buttonless" else "none";
        opacity = 1;
        padding = {
          x = 2;
          y = 2;
        };
      };
      font = {
        normal.family = "Fira Code";
        size = if stdenv.isDarwin then 15.0 else if stdenv.isAarch64 then 12.0 else 9.0;
      };
      colors = {
        primary = {
          background = "0x282a36";
          foreground = "0xf8f8f2";
        };
        cursor = {
          text = "CellBackground";
          cursor = "CellForeground";
        };
        vi_mode_cursor = {
          text = "CellBackground";
          cursor = "CellForeground";
        };
        search = {
          matches = {
            foreground = "0x44475a";
            background = "0x50fa7b";
          };
          focused_match = {
            foreground = "0x44475a";
            background = "0xffb86c";
          };
        };
        line_indicator = {
          foreground = "None";
          background = "None";
        };
        footer_bar = {
          foreground = "0xf8f8f2";
          background = "0x282a36";
        };
        selection = {
          text = "CellForeground";
          background = "0x44475a";
        };
        normal = {
          black = "0x000000";
          red = "0xff5555";
          green = "0x50fa7b";
          yellow = "0xf1fa8c";
          blue = "0xbd93f9";
          magenta = "0xff79c6";
          cyan = "0x8be9fd";
          white = "0xbfbfbf";
        };
        bright = {
          black = "0x4d4d4d";
          red = "0xff6e67";
          green = "0x5af78e";
          yellow = "0xf4f99d";
          blue = "0xcaa9fa";
          magenta = "0xff92d0";
          cyan = "0x9aedfe";
          white = "0xe6e6e6";
        };
        dim = {
          black = "0x14151b";
          red = "0xff2222";
          green = "0x1ef956";
          yellow = "0xebf85b";
          blue = "0x4d5b86";
          magenta = "0xff46b0";
          cyan = "0x59dffc";
          white = "0xe6e6d1";
        };
      };
      keyboard.bindings = [
        {
          key = "V";
          mods = "Command";
          action = "Paste";
        }
        {
          key = "C";
          mods = "Command";
          action = "Copy";
        }
        {
          key = "Q";
          mods = "Command";
          action = "Quit";
        }
        {
          key = "B";
          mods = "Alt";
          chars = "\\u001bb";
        }
        {
          key = "F";
          mods = "Alt";
          chars = "\\u001bf";
        }
        {
          key = "D";
          mods = "Alt";
          chars = "\\u001bd";
        }
      ];
    };
  };
}

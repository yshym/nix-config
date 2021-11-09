{ ... }:

let blue = "#3366CC";
in {
  fonts = {
    names = [ "Fira Code" ];
    size = 15;
  };

  window = {
    titlebar = false;
    border = 3;
  };

  focus = { followMouse = true; };

  # TODO: Set up application to workspace assignments
  # assigns = {};

  modifier = "Mod4";

  colors = {
    focused = {
      border = "#353439";
      background = blue;
      text = "#7B9F35";
      indicator = blue;
      childBorder = blue;
    };
  };

  # TODO: Set up startup commands
  # startup = {};

  gaps = {
    inner = 5;
    outer = 3;
    smartGaps = true;
  };

  menu = "rofi -show drun";

  terminal = "alacritty";
}

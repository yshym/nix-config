{ pkgs, ... }:

{
  services.spacebar = {
    enable = false;
    package = pkgs.spacebar;
    config = {
      position = "top";
      height = 30;
      spacing_left = 25;
      spacing_right = 15;
      text_font = ''"Helvetica Neue:Bold:14.0"'';
      icon_font = ''"Font Awesome 5 Free:Solid:14.0"'';
      background_color = "0xff282a36";
      foreground_color = "0xfff8f8f2";
      space_icon_color = "0xffbd93f9";
      power_icon_color = "0xfff1fa8c";
      battery_icon_color = "0xffff79c6";
      dnd_icon_color = "0xffa8a8a8";
      clock_icon_color = "0xff50fa7b";
      space_icon_strip = "     VI VII VIII IX X";
      power_icon_strip = " ";
      space_icon = "";
      clock_icon = "";
      dnd_icon = "";
      clock_format = ''"%d %a %R"'';
    };
  };
}

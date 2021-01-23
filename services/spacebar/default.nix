{ pkgs, ... }:

{
  services.spacebar = {
    enable = true;
    package = pkgs.spacebar;
    config = {
      position = "top";
      height = 30;
      spacing_left = 25;
      spacing_right = 15;
      text_font = ''"Helvetica Neue:Bold:14.0"'';
      icon_font = ''"Font Awesome 5 Free:Solid:14.0"'';
      background_color = "0xff202020";
      foreground_color = "0xffa8a8a8";
      space_icon_color = "0xff458588";
      power_icon_color = "0xffcd950c";
      battery_icon_color = "0xffd75f5f";
      dnd_icon_color = "0xffa8a8a8";
      clock_icon_color = "0xff95c6a0";
      space_icon_strip = "     VI VII VIII IX X";
      power_icon_strip = " ";
      space_icon = "";
      clock_icon = "";
      dnd_icon = "";
      clock_format = ''"%d %a %R"'';
    };
  };
}

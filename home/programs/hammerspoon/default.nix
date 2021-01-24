{ pkgs, ... }:

{
  home = {
    file.".hammerspoon/init.lua".source = ./.hammerspoon/init.lua;
    file.".hammerspoon/keyboardLayout".source = ./.hammerspoon/keyboardLayout;
  };
}

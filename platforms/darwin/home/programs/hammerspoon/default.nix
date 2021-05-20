{ pkgs, ... }:

{
  home = {
    file.".hammerspoon/init.lua".source = ./.hammerspoon/init.lua;
    file.".hammerspoon/stackline".source = ./.hammerspoon/stackline;
    file.".hammerspoon/keyboardLayout".source = ./.hammerspoon/keyboardLayout;
  };
}

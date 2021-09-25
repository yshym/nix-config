{ config, pkgs, ... }:

{
  programs.vscode = {
    enable = false;
    package = pkgs.vscodium;
    userSettings = {
      security.workspace.trust.untrustedFiles = "open";
      editor.fontSize = 15;
      python.linting.enabled = true;
      vim = {
        useSystemClipboard = true;
        vimrc = {
          enable = true;
          path = "~/.vimrc";
        };
        visualModeKeyBindings = [
          {
            before = [ ">" ];
            commands = [ "editor.action.indentLines" ];
          }
          {
            before = [ "<" ];
            commands = [ "editor.action.outdentLines" ];
          }
        ];
        visualModeKeyBindingsNonRecursive = [{
          before = [ "p" ];
          after = [ "p" "g" "v" "y" ];
        }];
      };
    };
  };
}

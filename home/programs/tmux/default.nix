{ config, lib, pkgs, ... }:

with lib;
let cfg = config.programs.tmux; in
{
  programs.tmux = {
    enable = true;
    mouse = true;
    shell = "${pkgs.zsh}/bin/zsh";
    sensibleOnTop = false;
    keyMode = "vi";
    customPaneNavigationAndResize = true;
    clock24 = true;
    plugins = with pkgs.tmuxPlugins; [
      yank
      {
        plugin = dracula;
        extraConfig = ''
          set -g @dracula-plugins " "
          set -g @dracula-show-powerline true
          set -g @dracula-show-left-icon "#h | #S"
          set -g @dracula-refresh-rate 10
        '';
      }
      {
        plugin = dotbar;
        extraConfig = ''
          set -g @tmux-dotbar-bg "default"
          set -g @tmux-dotbar-fg-current "#F8F8F2"
          set -g @tmux-dotbar-fg-session "#44475A"
          set -g @tmux-dotbar-fg-prefix "#BD93F9"
          set -g @tmux-dotbar-maximized-icon "⛶"
        '';
      }
      {
        plugin = tmux-fzf;
      }
    ];
    extraConfig = ''
      # Keep text highlighting after releasing the mouse button
      bind-key -T copy-mode-vi MouseDragEnd1Pane send-keys -X continue

      # Display a popup listing active sessions
      bind-key "S" run-shell "tmux-session-fzf"
    '';
  };

  home = mkIf cfg.enable {
    file.".local/bin/tmux-session-fzf".source = ./tmux-session-fzf.sh;
  };
}

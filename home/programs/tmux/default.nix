{ config, lib, pkgs, ... }:

with lib;
let cfg = config.programs.tmux; in
{
  programs.tmux = {
    enable = true;
    mouse = true;
    shell = "${pkgs.zsh}/bin/zsh";
    sensibleOnTop = false;
    baseIndex = 1;
    keyMode = "vi";
    customPaneNavigationAndResize = true;
    clock24 = true;
    historyLimit = 50000;
    plugins = with pkgs.tmuxPlugins; [
      yank
      {
        plugin = dracula;
        extraConfig = ''
          set -g @dracula-plugins " "
          set -g @dracula-show-powerline false
          set -g @dracula-show-left-icon "#h | #S"
          set -g @dracula-refresh-rate 10
          set -g mode-style "bg=#44475A,fg=default"
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
      tmux-fzf
    ];
    extraConfig = ''
      # Enable 256-color and truecolor support
      set -g default-terminal "tmux-256color"
      set -sa terminal-overrides ",alacritty*:RGB"

      # Renumber window after one is closed
      set -g renumber-windows on

      # Open panes in the current directory
      bind c new-window      -c "#{pane_current_path}"
      bind s split-window -v -c "#{pane_current_path}"
      bind v split-window -h -c "#{pane_current_path}"

      # Vim-like text selection
      bind -T copy-mode-vi v      send-keys -X begin-selection
      bind -T copy-mode-vi C-v    send-keys -X rectangle-toggle
      bind -T copy-mode-vi y      send-keys -X copy-selection-and-cancel
      bind -T copy-mode-vi Escape send-keys -X cancel

      # Keep text highlighting after releasing the mouse button
      bind -T copy-mode-vi MouseDragEnd1Pane send-keys -X continue

      # Display a popup listing active sessions
      bind "S" run-shell "tmux-session-fzf"

      # Disable confirmation
      bind x kill-pane
      bind X kill-window
      bind q kill-session
      bind Q kill-server
    '';
  };

  home = mkIf cfg.enable {
    file.".local/bin/tmux-session-fzf".source = ./tmux-session-fzf.sh;
  };
}

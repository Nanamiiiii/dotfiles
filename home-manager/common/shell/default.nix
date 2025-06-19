{
  pkgs,
  config,
  hostname,
  ...
}:
let
  configFiles = import ../../../config {
    inherit
      pkgs
      config
      hostname
      ;
  };
in
{
  imports = [ ./zsh.nix ];

  programs = {
    starship = {
      enable = true;
      settings = builtins.fromTOML (builtins.readFile ../../../config/starship/starship.toml);
    };
    tmux = {
      enable = true;
      shell = "${pkgs.zsh}/bin/zsh";
      terminal = "tmux-256color";
      baseIndex = 1;
      keyMode = "vi";
      prefix = "C-s";
      mouse = true;
      historyLimit = 999999999;
      extraConfig =
        ''
          set-option -a terminal-features ',xterm-256color:RGB'
          set-window-option -g xterm-keys on
          bind-key w split-window -h
          bind-key v split-window -v
          bind-key h select-pane -L
          bind-key j select-pane -D
          bind-key k select-pane -U
          bind-key l select-pane -R
          bind-key -T edit-mode-vi WheelUpPane send-keys -X scroll-up
          bind-key -T edit-mode-vi WheelDownPane send-keys -X scroll-down
          bind-key r source-file $XDG_CONFIG_HOME/tmux/tmux.conf \; display "Reloaded"
          set-option -g display-panes-time 2147483647
          set-option -g message-command-style bg=black,fg=cyan
          set-option -g message-style         bg=black,fg=cyan
          set-option -g bell-action none
          set-option -g focus-events on
          set-window-option -g aggressive-resize on
        ''
        + builtins.readFile ../../../config/tmux/tmux-style.conf
        + ''
          run-shell ${pkgs.tmuxPlugins.cpu.rtp}
          run-shell ${pkgs.tmuxPlugins.pain-control.rtp}
          run-shell ${pkgs.tmuxPlugins.prefix-highlight.rtp}
        '';
    };
  };

  home.packages = with pkgs; [ bc ];

  xdg.configFile = with configFiles.dotConfigs; tmux;
}

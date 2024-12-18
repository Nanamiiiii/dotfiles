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
    starship.enable = true;
  };

  home = {
    packages = with pkgs; [
      tmux
      tmuxPlugins.sensible
      tmuxPlugins.cpu
      tmuxPlugins.pain-control
      tmuxPlugins.prefix-highlight
    ];
  };

  xdg.configFile = with configFiles.dotConfigs; tmux // starship;
}

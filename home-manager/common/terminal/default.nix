{
  pkgs,
  lib,
  config,
  desktop,
  hostname,
  wslhost,
  inputs,
  ...
}:
let
  baseSystem = builtins.elemAt (builtins.split "-" pkgs.stdenv.hostPlatform.system) 2;

  configFiles = import ../../../config {
    inherit
      pkgs
      config
      hostname
      ;
  };

  weztermEnable = if desktop && baseSystem == "linux" then true else false;
in
lib.mkIf (!wslhost) {
  programs = {
    wezterm = {
      enable = weztermEnable;
      package = pkgs.wezterm;
    };
  };

  xdg.configFile = configFiles.dotConfigs.wezterm // {
    "wezterm/launcher.lua".source = pkgs.replaceVars ./launcher.lua {
      zsh_bin = "${pkgs.zsh}/bin/zsh";
      zellij_bin = "${pkgs.zellij}/bin/zellij";
      neovim_bin = "${inputs.neovim-nightly-overlay.packages.${pkgs.system}.default}/bin/nvim";
      ranger_bin = "${pkgs.ranger}/bin/ranger";
      btop_bin = "${pkgs.btop}/bin/btop";
      spotify_player_bin = "${pkgs.spotify-player}/bin/spotify_player";
    };
  };
}

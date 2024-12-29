{
  pkgs,
  config,
  desktop,
  hostname,
  inputs,
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

  ghosttyConfig = ''
    font-family = "PlemolJP Console"
    font-family = "Symbols Nerd Font"
    font-size = 14
    theme = "iceberg-dark"
    window-decoration = false
    window-padding-x = 10
    window-padding-y = 10
    window-padding-balance = true
    copy-on-select = true
    background-opacity = 0.90
    background-blur-radius = 10  
  '';
in
{
  imports = [ ];

  programs = {
    wezterm = {
      enable = desktop;
      package = inputs.wez-flake.packages.${pkgs.system}.default;
    };
  };

  home.packages = with pkgs; [
    ghostty
  ];

  xdg.configFile = configFiles.dotConfigs.wezterm // {
    "ghostty/config".text = ghosttyConfig;
  };
}

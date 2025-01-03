{
  pkgs,
  config,
  desktop,
  hostname,
  inputs,
  ...
}:
let
  baseSystem = builtins.elemAt (builtins.split "-" pkgs.system) 2;

  configFiles = import ../../../config {
    inherit
      pkgs
      config
      hostname
      ;
  };

  ghosttyConfigSpecific = {
    "darwin" = ''
      window-decoration = true
      macos-titlebar-style = hidden
      font-size = 16
    '';

    "linux" = ''
      window-decoration = false
      font-size = 14
    '';
  };

  ghosttyConfig =
    ''
      font-family = "PlemolJP Console"
      font-family = "Symbols Nerd Font"
      theme = "iceberg-dark"
      window-padding-x = 10
      window-padding-y = 10
      window-padding-balance = true
      window-theme = ghostty
      copy-on-select = true
      background-opacity = 0.90
      background-blur-radius = 10  
    ''
    + ghosttyConfigSpecific."${baseSystem}";
in
{
  imports = [ ];

  programs = {
    wezterm = {
      enable = desktop;
      package = inputs.wez-flake.packages.${pkgs.system}.default;
    };
  };

  xdg.configFile = configFiles.dotConfigs.wezterm // {
    "ghostty/config".text = ghosttyConfig;
  };
}

{
  pkgs,
  pkgs-stable,
  config,
  osConfig,
  desktop,
  ...
}:
let
  configFiles = import ../../config {
    inherit
      pkgs
      config
      osConfig
      ;
  };

  cliUtilities = with pkgs; [
    gawk
    gnutar
    gnused
    coreutils-prefixed # g-prefixed coreutils to avoid duplication
    wireguard-tools
    pngpaste
  ];

  desktopUtilities = with pkgs; [
    utm
  ];
in
{
  home.packages = cliUtilities ++ desktopUtilities;

  xdg.configFile = with configFiles.darwinConfigs; aerospace // raycast;

  programs = {
    ssh = {
      extraConfig =
        if desktop then
          ''
            Host *
                IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
          ''
        else
          "";
    };
  };
}

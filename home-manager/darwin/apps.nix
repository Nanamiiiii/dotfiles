{
  pkgs,
  pkgs-stable,
  lib,
  config,
  desktop,
  hostname,
  ...
}:
let
  configFiles = import ../../config {
    inherit
      pkgs
      config
      hostname
      ;
  };

  cliUtilities = with pkgs; [
    gawk
    gnutar
    gnused
    coreutils-prefixed # g-prefixed coreutils to avoid duplication
    #wireguard-tools # broken now
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
      extraConfig = lib.mkIf desktop ''
        Host *
            IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
      '';
    };
  };
}

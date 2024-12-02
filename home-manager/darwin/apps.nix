{
  pkgs,
  pkgs-stable,
  config,
  osConfig,
  ...
}:
let
  configFiles = import ../../../config {
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
    aerospace
    raycast
    utm
  ];
in
{
  home.packages = cliUtilities ++ desktopUtilities;

  xdg.configFile = with configFiles.darwinConfigs; aerospace // raycast;

  programs = {
    ssh = {
      extraConfig = if desktop then ''
        Host *
            IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
      '' else "";
    };
  };

  launchd.agents = {
    aerospace = {
      enable = true;
      config = {
        ProgramArguments = [
          "${pkgs.aerospace}/Applications/AeroSpace.app/Contents/MacOS/AeroSpace"
        ];
        RunAtLoad = true;
        KeepAlive = true;
      };
    };

    raycast = {
      enable = true;
      config = {
        ProgramArguments = [ "${pkgs.raycast}/Applications/Raycast.app/Contents/MacOS/Raycast" ];
        RunAtLoad = true;
        KeepAlive = true;
      };
    };
  };
}

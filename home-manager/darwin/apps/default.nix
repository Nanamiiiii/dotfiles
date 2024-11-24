{
  pkgs,
  pkgs-unstable,
  config,
  hostname,
  ...
}:
let
  configFiles = import ../../../config { inherit config hostname; };

  cliUtilities = with pkgs; [
    gawk
    gnutar
    gnused
    coreutils-prefixed # g-prefixed coreutils to avoid duplication
    wireguard-tools
    pngpaste
  ];

  desktopUtilities = with pkgs; [
    pkgs-unstable.aerospace
    pkgs-unstable.raycast
    utm
  ];
in
{
  home.packages = cliUtilities ++ desktopUtilities;

  xdg.configFile = with configFiles.darwinConfigs; aerospace // raycast;

  launchd.agents = {
    aerospace = {
      enable = true;
      config = {
        ProgramArguments = [
          "${pkgs-unstable.aerospace}/Applications/AeroSpace.app/Contents/MacOS/AeroSpace"
          "--started-at-login"
        ];
        RunAtLoad = true;
        KeepAlive = true;
      };
    };

    raycast = {
      enable = true;
      config = {
        ProgramArguments = [ "${pkgs-unstable.raycast}/Applications/Raycast.app/Contents/MacOS/Raycast" ];
        RunAtLoad = true;
        KeepAlive = true;
      };
    };
  };
}

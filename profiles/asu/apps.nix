{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    aerospace
    raycast
  ];

  launchd.user.agents = {
    aerospace = {
      serviceConfig = {
        ProgramArguments = [
          "${pkgs.aerospace}/Applications/AeroSpace.app/Contents/MacOS/AeroSpace"
        ];
        RunAtLoad = true;
        KeepAlive = true;
      };
    };

    raycast = {
      serviceConfig = {
        ProgramArguments = [ "${pkgs.raycast}/Applications/Raycast.app/Contents/MacOS/Raycast" ];
        RunAtLoad = true;
        KeepAlive = true;
      };
    };
  };
}

{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    aerospace
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
  };
}

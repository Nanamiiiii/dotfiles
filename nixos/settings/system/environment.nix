{ pkgs, ... }:
{
  environment = {
    systemPackages = with pkgs; [
      vim
      gnumake
      git
      curl
      killall
    ];
  };
}

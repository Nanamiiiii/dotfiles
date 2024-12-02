{ pkgs, ... }:
{
  environment = {
    systemPackages = with pkgs; [
      vim
      gnumake
      git
      curl
      bash
    ];
  };
}

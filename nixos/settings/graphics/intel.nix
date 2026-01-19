{ pkgs, ... }:
{
  hardware = {
    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver
      ];
    };
  };
  environment.systemPackages = with pkgs; [
    libGL
    intel-gpu-tools
  ];
}

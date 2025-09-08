# Reference: https://github.com/turtton/dotnix/blob/main/home-manager/wm/hyprland/nvidia.nix
{ pkgs, ... }:
{
  home.packages = [
    pkgs.nvidia-vaapi-driver
  ];
  wayland.windowManager.hyprland.settings = {
    env = [
      "LIBVA_DRIVER_NAME,nvidia"
      "XDG_SESSION_TYPE,wayland"
      "GBM_BACKEND,nvidia-drm"
      "__GLX_VENDOR_LIBRARY_NAME,nvidia"
      "NVD_BACKEND,direct"
    ];
    cursor.no_hardware_cursors = true;
  };
}

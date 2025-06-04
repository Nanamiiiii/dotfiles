{ inputs, pkgs, ... }:
let
  tools = import ./tools.nix;
in
{
  imports = [
    inputs.hyprland.nixosModules.default
  ];

  programs = {
    hyprland = {
      enable = true;
      xwayland = {
        enable = true;
      };
    };
    hyprlock = {
      enable = true;
    };
  };

  # Sync clipboard between wayland and X11
  systemd.user.services.wl-x11-clipsync = {
    description = "Clipboard Sync Service";
    wantedBy = [ "graphical.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.wl-x11-clipsync}/bin/clipsync";
      Restart = "on-failure";
    };
  };
}

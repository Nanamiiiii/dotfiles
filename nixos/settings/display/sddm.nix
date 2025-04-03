{
  pkgs,
  lib,
  config,
  extraWestonConfig ? null,
  ...
}:
let
  sddm-astronaut-theme = pkgs.callPackage ../../../packages/sddm-astronaut.nix {
    theme = "hyprland_kath";
  };
in
{
  services.displayManager.sddm =
    if extraWestonConfig != null then
      {
        enable = true;
        package = pkgs.kdePackages.sddm;
        wayland = {
          enable = true;
          compositorCommand = "${lib.getExe pkgs.weston} --shell=kiosk -c ${extraWestonConfig}";
        };
        #theme = "catppuccin-macchiato";
        theme = "sddm-astronaut-theme";
        settings = {
          General = {
            InputMethod = "qtvirtualkeyboard";
          };
        };
        extraPackages = with pkgs; [
          kdePackages.qtsvg
          kdePackages.qtmultimedia
          kdePackages.qtvirtualkeyboard
        ];
      }
    else
      {
        enable = true;
        package = pkgs.kdePackages.sddm;
        wayland = {
          enable = false;
        };
        #theme = "catppuccin-macchiato";
        theme = "sddm-astronaut-theme";
        settings = {
          General = {
            InputMethod = "qtvirtualkeyboard";
          };
        };
        extraPackages = with pkgs; [
          kdePackages.qtsvg
          kdePackages.qtmultimedia
          kdePackages.qtvirtualkeyboard
        ];
      };

  environment.systemPackages = [
    #(pkgs.catppuccin-sddm.override {
    #  flavor = "macchiato";
    #  font = "IBM Plex Sans JP";
    #  fontSize = "14";
    #})
    sddm-astronaut-theme
  ];

  # Setup Avatar
  # Reference: https://github.com/thomX75/nixos-modules
  systemd.services."sddm-avatar" = {
    description = "Service to copy or update users Avatars at startup.";
    wantedBy = [ "multi-user.target" ];
    before = [ "display-manager.service" ];
    script = ''
      set -eu
      for user in /home/*; do
          username=$(basename "$user")
          if [ -f "$user/.face.icon" ]; then
              if [ ! -f "/var/lib/AccountsService/icons/$username" ]; then
                  cp "$user/.face.icon" "/var/lib/AccountsService/icons/$username"
              else
                  if [ "$user/.face.icon" -nt "/var/lib/AccountsService/icons/$username" ]; then
                      cp "$user/.face.icon" "/var/lib/AccountsService/icons/$username"
                  fi
              fi
          fi
      done
    '';
    serviceConfig = {
      Type = "simple";
      User = "root";
      StandardOutput = "journal+console";
      StandardError = "journal+console";
    };
  };
}

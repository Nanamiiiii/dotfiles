{
  pkgs,
  lib,
  config,
  extraWestonConfig ? null,
  ...
}:
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
        theme = "catppuccin-macchiato";
      }
    else
      {
        enable = true;
        package = pkgs.kdePackages.sddm;
        wayland = {
          enable = true;
        };
        theme = "catppuccin-macchiato";
      };

  environment.systemPackages = with pkgs; [
    (pkgs.catppuccin-sddm.override {
      flavor = "macchiato";
      font = "IBM Plex Sans JP";
      fontSize = "14";
    })
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
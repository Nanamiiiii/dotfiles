{
  pkgs,
  lib,
  config,
  wayland ? true,
  extraWestonConfig ? null,
  ...
}:
{
  services.displayManager.sddm =
    if wayland then
      (
        if extraWestonConfig != null then
          {
            enable = true;
            package = lib.mkForce pkgs.kdePackages.sddm;
            wayland = {
              enable = true;
              compositorCommand = "${lib.getExe pkgs.weston} --shell=kiosk -c ${extraWestonConfig}";
            };
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
            package = lib.mkForce pkgs.kdePackages.sddm;
            wayland = {
              enable = true;
              compositor = "kwin";
            };
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
      )
    else
      {
        enable = true;
        package = lib.mkForce pkgs.kdePackages.sddm;
        wayland = {
          enable = false;
        };
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
    (pkgs.sddm-astronaut.override {
      theme = "hyprland_kath";
    })
  ];
}

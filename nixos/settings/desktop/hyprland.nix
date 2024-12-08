{ inputs, ... }:
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
}

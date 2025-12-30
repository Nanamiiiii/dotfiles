{
  pkgs,
  config,
  ...
}:
let
  # WSL
  wslSettings = [
    ../../nix-wsl/settings/system/user.nix
    (import ../../nix-wsl/settings/system/networking.nix { hostName = "saki"; })
    ../../nix-wsl/settings/system/graphics.nix
    ../../nix-wsl/settings/system/fonts.nix
    ../../nix-wsl/settings/apps
  ];

  # Nix Settings
  nixSettings = [
    ../../nixos/settings/nix/nix.nix
    ../../nixos/settings/nix/nixpkgs.nix
  ];

  # System
  systemSettings = [
    ../../nixos/settings/system/environment.nix
    ../../nixos/settings/system/time.nix
    ../../nixos/settings/system/i18n.nix
    ../../nixos/settings/system/yubikey.nix
  ];

  # Misc
  misc = [
    ../../nixos/settings/misc/programs.nix
  ];
in
{
  imports = wslSettings ++ nixSettings ++ systemSettings ++ misc;

  system.stateVersion = "24.11";
}

{ pkgs, username, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../nixos/settings/nix/nix.nix
    ../../nixos/settings/nix/nixpkgs.nix
    (import ../../nixos/settings/system/networking.nix { hostName = "misaki"; })
    ../../nixos/settings/system/time.nix
    ../../nixos/settings/system/i18n.nix
    ../../nixos/settings/misc/ssh.nix
    ../../nixos/settings/misc/sops.nix
    ../../nixos/settings/misc/nixbuild.nix
  ];

  users.users.${username} = {
    description = "Akihiro Saiki";
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" ];
  };

  programs.zsh.enable = true;

  system.stateVersion = "26.05";
}

{ config, username, ... }:
let
  systemSettings = [
    ../../nix-darwin/settings/system/darwin-system.nix
    ../../nix-darwin/settings/system/ssh.nix
    ../../nix-darwin/settings/system/brew.nix
    ../../nix-darwin/settings/system/sops.nix
    ../../nix-darwin/settings/system/user.nix
    ../../nix-darwin/settings/system/shell.nix
    ../../nix-darwin/settings/system/security.nix
    ../../nix-darwin/settings/system/timezone.nix
    (import ../../nix-darwin/settings/system/networking.nix { hostName = "suisui"; })
    ../../nix-darwin/settings/system/environment.nix
    ../../nix-darwin/settings/system/fonts.nix
  ];

  nixSettings = [
    ../../nix-darwin/settings/nix/nix.nix
    ../../nix-darwin/settings/nix/nixpkgs.nix
    ../../nix-darwin/settings/nix/cachix.nix
  ];

  brewApps = [
    ../../nix-darwin/settings/brew/keyboard.nix
    ../../nix-darwin/settings/brew/skk.nix
    ../../nix-darwin/settings/brew/vpn.nix
    ../../nix-darwin/settings/brew/fuse.nix
    ../../nix-darwin/settings/brew/proton.nix
    ../../nix-darwin/settings/brew/devtool.nix
    ../../nix-darwin/settings/brew/menubar.nix
    ../../nix-darwin/settings/brew/browsers.nix
  ];

in
{
  imports = systemSettings ++ nixSettings ++ brewApps;

  sops.secrets = {
    cachix-agent.sopsFile = ./secrets.yaml;
    pam-u2f.sopsFile = ./secrets.yaml;
  };

  homebrew.casks = [
    # keybinding
    "homerow"

    # filesystem
    "cryptomator"

    # cloud storage
    "nextcloud-vfs"
    "onedrive"
    "box-drive"
    "box-tools"

    # communication
    "slack"
    "discord"
    "microsoft-teams"
    "zoom"

    # ai
    "claude"

    # media
    "vlc"
    "skim"
    "spotify"

    # devices
    "logi-options+"

    # note
    "obsidian"

    # research
    "zotero"
    "grammarly-desktop"

    # adobe
    "adobe-creative-cloud"

    # games
    "steam"
  ];
}

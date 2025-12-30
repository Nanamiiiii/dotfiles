{
  pkgs,
  lib,
  config,
  ...
}:
let
  commonConfigs = [
    ../../common
    ../../common/nix
    ../../common/cli
    ../../common/cli/git
    (import ../../common/cli/gpg {
      inherit pkgs lib;
      enableAgent = false;
      pinentryVariant = null;
    })
    ../../common/cli/ssh
    ../../common/apps/skk
    ../../common/editor/neovim
    ../../common/editor/zed
    ../../common/editor/code
    ../../common/lang
    ../../common/shell/zsh
    ../../common/shell/tmux
    ../../common/shell/starship
    ../../common/shell/zellij
    ../../common/terminal
  ];

  linuxConfigs = [
    ../../linux/apps
    ../../linux/fcitx5
  ];

  wslConfigs = [
    ../../wsl
  ];

  sopsConfigs = [
    ../../sops
  ];

  symlink = config.lib.file.mkOutOfStoreSymlink;
in
{
  imports = commonConfigs ++ linuxConfigs ++ wslConfigs ++ sopsConfigs;

  programs.ssh = {
    extraConfig = ''
      Include ${config.home.homeDirectory}/.ssh/conf.d/lab.conf
      Include ${config.home.homeDirectory}/.ssh/conf.d/apal.conf
    '';
  };

  sops.secrets = {
    ssh-hosts-kasalab = { };
    ssh-hosts-apal = { };
  };

  home.file = {
    ".ssh/conf.d/lab.conf" = {
      source = symlink "${config.sops.secrets.ssh-hosts-kasalab.path}";
    };
    ".ssh/conf.d/apal.conf" = {
      source = symlink "${config.sops.secrets.ssh-hosts-apal.path}";
    };
  };

  home.stateVersion = "25.11";
}

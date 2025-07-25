{ config, ... }:
let
  symlink = config.lib.file.mkOutOfStoreSymlink;
in
{
  imports = [
    ../../fcitx5
  ];

  programs.ssh = {
    extraConfig = ''
      Include ${config.home.homeDirectory}/.ssh/conf.d/lab.conf
      Include ${config.home.homeDirectory}/.ssh/conf.d/apal.conf
    '';
  };

  sops.secrets.ssh-hosts-kasalab = { };
  sops.secrets.ssh-hosts-apal = { };

  home.file = {
    ".ssh/conf.d/lab.conf" = {
      source = symlink "${config.sops.secrets.ssh-hosts-kasalab.path}";
    };
    ".ssh/conf.d/apal.conf" = {
      source = symlink "${config.sops.secrets.ssh-hosts-apal.path}";
    };
  };
}

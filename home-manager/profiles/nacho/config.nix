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
      Include ${config.home.homeDirectory}/.ssh/conf.d/apal.conf
    '';
  };

  sops.secrets.ssh-hosts-apal = { };
  #sops.secrets.docker-lab-proxy = { };

  # Docker Proxy Settings
  home.file = {
    ".ssh/conf.d/apal.conf" = {
      source = symlink "${config.sops.secrets.ssh-hosts-apal.path}";
    };
    #".docker/config.json" = {
    #  source = symlink "${config.sops.secrets.docker-lab-proxy.path}";
    #};
  };
}

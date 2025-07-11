{ config, ... }:
let
  symlink = config.lib.file.mkOutOfStoreSymlink;
in
{
  imports = [
    ../../fcitx5
  ];

  sops.secrets.docker-lab-proxy = { };

  # Docker Proxy Settings
  home.file = {
    ".docker/config.json" = {
      source = symlink "${config.sops.secrets.docker-lab-proxy.path}";
    };
  };
}

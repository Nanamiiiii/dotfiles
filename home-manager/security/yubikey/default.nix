{ config, ... }:
let
  symlink = config.lib.file.mkOutOfStoreSymlink;
in
{
  xdg.configFile."Yubico/u2f_keys" = {
    source = symlink "${config.sops.secrets.pam-u2f.path}";
  };
}

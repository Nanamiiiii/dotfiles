{ pkgs, ... }:
{
  services = {
    gvfs.enable = true;
    rpcbind.enable = true;
  };

  environment.systemPackages = with pkgs; [
    gnome.gvfs
    nfs-utils
  ];
}

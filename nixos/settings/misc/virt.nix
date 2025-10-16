{ pkgs, username, ... }:
{
  virtualisation = {
    docker = {
      enable = true;
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };

    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        swtpm.enable = true;
        vhostUserPackages = [ pkgs.virtiofsd ];
      };
    };

    spiceUSBRedirection.enable = true;
  };

  users.extraGroups.vboxusers.members = [ "${username}" ];
}

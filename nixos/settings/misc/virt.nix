{ pkgs, username, ... }:
{
  virtualisation = {
    #docker = {
    #  enable = true;
    #  rootless = {
    #    enable = true;
    #    setSocketVariable = true;
    #  };
    #};

    podman = {
      enable = true;
      dockerCompat = true;
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

  environment.systemPackages = [ pkgs.distrobox ];

  environment.etc."distrobox/distrobox.conf".text = ''
    container_additional_volumes="/nix/store:/nix/store:ro /etc/profiles/per-user:/etc/profiles/per-user:ro /etc/static/profiles/per-user:/etc/static/profiles/per-user:ro"
  '';

  users.extraGroups.vboxusers.members = [ "${username}" ];
}

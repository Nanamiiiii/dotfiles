{ pkgs, username, ... }:
{
  users = {
    users.${username} = {
      isNormalUser = true;
      shell = pkgs.zsh;
      extraGroups = [
        "networkmanager"
        "wheel"
        "kvm"
        "qemu-libvirtd"
        "uucp"
        "dialout"
        "lp"
      ];
    };
  };
}

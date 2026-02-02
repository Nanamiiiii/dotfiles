{ pkgs, username, ... }:
{
  users = {
    users.${username} = {
      description = "Akihiro Saiki";
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
        "video"
      ];
    };
  };
}

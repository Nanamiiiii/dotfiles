{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    #gnupg
    #yubikey-manager
    pam_u2f
  ];
}

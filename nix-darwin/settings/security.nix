{
  pkgs,
  lib,
  config,
  ...
}:
{
  security.pam.services.sudo_local = {
    touchIdAuth = true;
    reattach = true;
    text = lib.mkAfter ''
      auth sufficient ${pkgs.pam_u2f}/lib/security/pam_u2f.so authfile=${config.sops.secrets.pam-u2f.path} cue
    '';
  };
}

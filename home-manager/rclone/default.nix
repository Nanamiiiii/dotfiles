{ pkgs, config, ... }:
let
  dropboxDir = "${config.home.homeDirectory}/Dropbox";
in
{
  sops.secrets.rclone-dropbox = { };
  systemd.user.services.rclone-dropbox-mount = {
    Unit = {
      Description = "Mount dropbox via rclone";
      Wants = [ "sops-nix.service" ];
      After = [ "sops-nix.service" ];
    };
    Service = {
      Type = "notify";
      ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p ${dropboxDir}";
      ExecStart = "${pkgs.rclone}/bin/rclone --config=${config.sops.secrets.rclone-dropbox.path} --vfs-cache-mode writes --ignore-checksum mount Dropbox: ${dropboxDir}";
      ExecStop = "/run/wrappers/bin/fusermount -u ${dropboxDir}";
      Environment = [ "PATH=${pkgs.fuse}/bin:/run/wrappers/bin:$PATH" ];
      Restart = "on-failure";
      RestartSec = "60s";
    };
    Install.WantedBy = [ "default.target" ];
  };
}

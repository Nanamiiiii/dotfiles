{ pkgs, config, ... }:
{
  sops.secrets.rclone-dropbox = { };
  systemd.user.services.rclone-dropbox-mount = {
    Unit = {
      Description = "Mount dropbox via rclone";
      After = [ "network-online.target" ];
    };
    Service = {
      Type = "notify";
      ExecStartPre = "/usr/bin/env mkdir -p %h/Dropbox";
      ExecStart = "${pkgs.rclone}/bin/rclone --config=${config.sops.secrets.rclone-dropbox.path} --vfs-cache-mode writes --ignore-checksum mount \"Dropbox:\" \"Dropbox\"";
      ExecStop = "/bin/fusermount -u %h/Dropbox/%i";
    };
    Install.WantedBy = [ "default.target" ];
  };
}

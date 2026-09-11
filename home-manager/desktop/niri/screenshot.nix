{ pkgs, lib, ... }:
let
  screenshotUploader = pkgs.writeShellApplication {
    name = "niri-proton-screenshot-upload";

    runtimeInputs = with pkgs; [
      proton-drive-cli
      libnotify
      util-linux
    ];

    text = ''
      if [[ $# -ne 1 ]]; then
        echo "usage: niri-proton-screenshot-upload <path>" >&2
        exit 2
      fi

      path="$1"
      remote="/my-files/Pictures/Screenshots"

      if [[ ! -f "$path" ]]; then
        echo "file does not exist: $path" >&2
        exit 1
      fi

      filename="$(basename "$path")"

      lock="''${XDG_RUNTIME_DIR}/niri-proton-screenshot-upload.lock"

      exec 9>"$lock"
      flock 9

      if proton-drive filesystem upload \
          --file-conflict-strategy skip \
          "$path" "$remote"; then
        notify-send -a "Screenshot Uploader" \
          "Screenshot uploaded to Proton Drive" \
          "$filename"
      else
        notify-send -a "Screenshot Uploader" \
          --urgency=critical \
          "Failed to upload screenshot" \
          "$filename"

        exit 1
      fi
    '';
  };

  screenshotWatcher = pkgs.writeShellApplication {
    name = "niri-proton-screenshot-watcher";

    runtimeInputs = with pkgs; [
      niri
      jq
      systemd
    ];

    text = ''
      counter=0

      niri msg --json event-stream \
        | jq --unbuffered -r '
            select(.ScreenshotCaptured? != null)
            | .ScreenshotCaptured.path // empty
          ' \
        | while IFS= read -r path; do
            [[ -f "$path" ]] || continue

            counter=$((counter + 1))

            unit="niri-proton-screenshot-upload-$$-$counter"

            systemd-run \
              --user \
              --quiet \
              --collect \
              --unit="$unit" \
              --property=Type=exec \
              --property=TimeoutStartSec=10min \
              -- \
              ${lib.getExe screenshotUploader} "$path"
          done
    '';
  };
in
{
  systemd.user.services.niri-proton-screenshot-watcher = {
    Unit = {
      Description = "Watch niri screenshots and enqueue Proton Drive uploads";

      After = [
        "graphical-session.target"
      ];

      Requisite = [
        "graphical-session.target"
      ];

      PartOf = [
        "graphical-session.target"
      ];
    };

    Service = {
      Type = "simple";
      ExecStart = lib.getExe screenshotWatcher;

      Restart = "always";
      RestartSec = 1;
    };

    Install = {
      WantedBy = [
        "graphical-session.target"
      ];
    };
  };
}

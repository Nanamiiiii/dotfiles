{ ... }:
{
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      cleanup = "uninstall";
    };

    brews = [
      "displayplacer"
      "pinentry-mac"
    ];

    casks = [
      "1password"
      "1password-cli"
      "istat-menus"
      "homerow"
      "karabiner-elements"
      "notchnook"
      "microsoft-edge"
      "fuse-t"
      "macos-fuse-t/homebrew-cask/fuse-t-sshfs"
      "cryptomator"
      "nextcloud-vfs"
      "onedrive"
      "firefox"
      "tailscale-app"
    ];

    taps = [
      "nikitabobko/tap"
      "xpipe-io/tap"
      "FelixKratz/formulae"
      "macos-fuse-t/homebrew-cask"
    ];
  };
}

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
      "protonpass/tap/pass-cli"
    ];

    casks = [
      #"1password"
      #"1password-cli"
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
      "proton-mail"
      "proton-drive"
      "proton-pass"
      "protonvpn"
      "thaw"
    ];

    taps = [
      "nikitabobko/tap"
      "xpipe-io/tap"
      "FelixKratz/formulae"
      "macos-fuse-t/homebrew-cask"
      "protonpass/tap"
    ];
  };
}

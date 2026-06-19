{
  homebrew = {
    casks = [
      "fuse-t"
      "macos-fuse-t/homebrew-cask/fuse-t-sshfs"
    ];

    taps = [
      {
        name = "macos-fuse-t/homebrew-cask";
        trusted = true;
      }
    ];
  };
}

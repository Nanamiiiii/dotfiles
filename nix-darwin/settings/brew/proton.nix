{
  homebrew = {
    brews = [
      "protonpass/tap/pass-cli"
    ];

    casks = [
      "proton-mail"
      "proton-pass"
      "protonvpn"
      "proton-drive"
    ];

    taps = [
      {
        name = "protonpass/tap";
        trusted = true;
      }
    ];
  };
}

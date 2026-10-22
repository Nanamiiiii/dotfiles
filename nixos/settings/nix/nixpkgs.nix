{
  nixpkgs = {
    config.allowUnfree = true;
    config.permittedInsecurePackages = [
      "firefox-esr-140-bin-unwrapped-140.17.0esr"
    ];
  };
}

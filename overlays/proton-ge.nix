final: prev: {
  proton-ge = prev.stdenv.mkDerivation rec {
    pname = "proton-ge-custom";
    version = "GE-Proton9-21";

    src = prev.fetchurl {
      url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/${version}.tar.gz";
      hash = "sha256-91UwM1/vtteZQsIerdIclPUiGArlidtVs8o/IWbpSwQ=";
    };

    buildCommand = ''
      runHook preBuild

      mkdir -p $out/bin
      tar -C $out/bin --strip=1 -x -f $src

      runHook postBuild
    '';

    passthru.updateScript = prev.nix-update-script { };

    meta = with prev.lib; {
      description = "Compatibility tool for Steam Play based on Wine and additional components";
      homepage = "https://github.com/GloriousEggroll/proton-ge-custom";
      license = licenses.bsd3;
      platforms = [ "x86_64-linux" ];
      maintainers = with maintainers; [ ataraxiasjel ];
      preferLocalBuild = true;
    };
  };
}

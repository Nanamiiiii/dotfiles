{ inputs, ... }:
{
  nixpkgs.overlays = [
    inputs.nur.overlays.default
    inputs.llm-agents.overlays.shared-nixpkgs
    (final: prev: {
      microsoft-edge = prev.microsoft-edge.overrideAttrs (old: {
        postInstall = (old.postInstall or "") + ''
          wrapProgram "$out/bin/microsoft-edge" \
            --set LANGUAGE ja
        '';
      });
    })
  ];
}

{ inputs, ... }:
{
  nixpkgs.overlays = [
    inputs.nur.overlays.default
    inputs.llm-agents.overlays.shared-nixpkgs
    (final: prev: {
      spotify-player =
        if final.stdenv.hostPlatform.isDarwin then
          prev.spotify-player.overrideAttrs (old: {
            nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ final.llvmPackages.lld ];

            env = (old.env or { }) // {
              NIX_CFLAGS_LINK = final.lib.concatStringsSep " " [
                ((old.env or { }).NIX_CFLAGS_LINK or "")
                "--ld-path=${final.lib.getExe' final.llvmPackages.lld "ld64.lld"}"
              ];
            };
          })
        else
          prev.spotify-player;
    })
  ];
}

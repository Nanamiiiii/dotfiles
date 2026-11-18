{
  inputs,
  pkgs,
  lib,
  desktop,
  ...
}:
let
  baseSystem = builtins.elemAt (builtins.split "-" pkgs.stdenv.hostPlatform.system) 2;
in
{
  home.packages =
    with inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
    [
      claude-code
      codex
    ]
    ++ lib.optionals (baseSystem == "linux" && desktop) (
      with inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
      [
        claude-desktop
        chatgpt
      ]
    );
}

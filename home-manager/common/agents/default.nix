{
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
    with pkgs.llm-agents;
    [
      claude-code
      codex
    ]
    ++ lib.optionals (baseSystem == "linux" && desktop) [
      pkgs.llm-agents.claude-desktop
      pkgs.llm-agents.chatgpt
    ];
}

{ pkgs, ... }:
{
  home.packages = [
    pkgs.llm-agents.claude-code
    pkgs.llm-agents.codex
  ];
}

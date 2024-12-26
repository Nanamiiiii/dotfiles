{ inputs, system, ... }:
final: prev: {
  zen-browser = inputs.zen-browser.packages."${system}".default;
}

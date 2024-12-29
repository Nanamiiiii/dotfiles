{ inputs, system, ... }:
final: prev: {
  ghostty = inputs.ghostty.packages."${system}".default;
}

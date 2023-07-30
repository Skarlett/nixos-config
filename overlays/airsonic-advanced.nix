{nixpkgs, config, ...}:
let
  nixpkgs' = import nixpkgs config;
in
final: prev: {
  airsonic-advanced = nixpkgs'.callPackage ./packages/airsonic-advanced.nix {};
}

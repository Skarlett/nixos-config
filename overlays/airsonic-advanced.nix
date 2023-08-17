{config, ...}:
final: prev: {
  airsonic-advanced = prev.callPackage ./packages/airsonic-advanced.nix {};
}

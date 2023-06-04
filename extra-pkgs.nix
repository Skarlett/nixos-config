{self, config, pkgs, ...}:
{
  nixpkgs.overlays = with self.inputs; [
    (final: prev: {
        unstable = import nixpkgs-unstable {
          inherit (pkgs.stdenv.hostPlatform) system;
          config.allowUnfree = true;
        };
      })
      nur.overlay
      nix-alien.overlays.default
    ];
}
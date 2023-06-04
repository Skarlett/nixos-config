{config, self, ...}:
{
  nixpkgs.overlays = with self.inputs; [
    (final: prev: {
        unstable = import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        };
      })
      nur.overlay
      nix-alien.overlays
    ];
}
{config, self, ...}:
{
  nixpkgs.overlays = [
    (final: prev: {
        unstable = import self.inputs.nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        };
      })

      inputs.nur.overlay
      inputs.nix-alien.overlays.default
    ];
}
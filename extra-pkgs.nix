{self, inputs, config, pkgs, lib, ...}:
let cfg = {
      inherit (pkgs.stdenv.hostPlatform) system;
      config.allowUnfree = true;
  };
in
{
  # add all inputs to registry
  nix.registry = builtins.mapAttrs (k: v: { flake = v; }) inputs;
  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = with inputs; [
      (final: prev: {
        unstable = import nixpkgs-unstable cfg;
        raccoon = import raccoon cfg;
      })
      (final: prev: {
        self = self.outputs.packages.${pkgs.stdenv.hostPlatform.system};
      })

      vscode-extensions.overlays.default
      nix-alien.overlays.default
      nur.overlay
      chaotic.overlays.default
  ];
}

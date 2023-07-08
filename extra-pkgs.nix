{inputs, config, pkgs, lib, ...}:
let cfg = {
  inherit (pkgs.stdenv.hostPlatform) system;
    config.allowUnfree = true;
  };
in
{
  # add all inputs to registry
  nix.registry = builtins.mapAttrs (k: v: { flake = v; }) inputs;
  nixpkgs.overlays = with inputs; [
      (final: prev: {
        unstable = import nixpkgs-unstable cfg;
        raccoon = import raccoon cfg; 
      })
      emacs-overlay.overlays.default
      vscode-extensions.overlays.default
      nur.overlay
      nix-alien.overlays.default
    ];
}

{inputs, config, pkgs, ...}:
let cfg = {
  inherit (pkgs.stdenv.hostPlatform) system;
    config.allowUnfree = true;
  };
in
{
  nixpkgs.overlays = with inputs; [
    (final: prev: {
        unstable = import nixpkgs-unstable cfg;
        raccoon = import raccoon cfg; 
      })
      vscode-extensions.overlays.default
      nur.overlay
      nix-alien.overlays.default
    ];
}

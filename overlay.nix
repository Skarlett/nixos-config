{ config, lib, pkgs, nixpkgs-unstable, ... }:
let
  overlay = final: prev: {
      unstable = import nixpkgs-unstable {
          system = pkgs.stdenv.hostPlatform.system;
          config.allowUnfree = true;
      };
  };

  cfg = config.overlays.unstable;
in
{
  options.overlays.unstable = {
    enable = lib.mkEnableOption "hello service";
  };

  config = lib.mkIf cfg.enable {
    nixpkgs.overlays = [ overlay ];
  };
}

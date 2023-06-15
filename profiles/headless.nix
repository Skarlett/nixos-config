{ config, lib, pkgs, inputs, ... }:
{
  imports = [
    "${inputs.nixpkgs}/nixos/modules/profiles/headless.nix"
    ../modules/accessible.nix
    ./common.nix
  ];
}

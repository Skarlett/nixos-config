{ config, lib, pkgs, ... }:

{
  imports = [
    ../modules/common.nix
    ../extra-pkgs.nix
  ];
}

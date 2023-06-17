{ inputs, config, lib, pkgs, ... }:

{
  imports = [
    ./headless.nix
    "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
  ];

  environment.systemPackages = with pkgs; [
    gnufdisk
    util-linux
    parted
    nfs-utils
  ];
}

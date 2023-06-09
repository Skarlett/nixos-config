{ config, lib, pkgs, ... }:

{
  imports = [
    ../modules/fail2ban.nix
    ./common.nix
  ];
}

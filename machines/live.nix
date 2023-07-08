{config, lib, pkgs, ...}:
{
  networking.hostName = "liveiso";
  services.openssh.enable = true;
  system.stateVersion = "23.05";
  services.lvm.enable = false;

  environment.systemPackages = [ pkgs.nixos-install-tools ];
}

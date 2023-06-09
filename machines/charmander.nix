{config, pkgs, lib, ...}:
{
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sde";

  networking.hostName = "charmander";
  services.openssh.enable = true;
}

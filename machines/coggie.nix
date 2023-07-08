{ keys, pkgs, config, lib, ... }: 
{
  # boot.kernelPackages = pkgs.linuxPackages_rpi3;
  services.lvm.enable = false;
  system.stateVersion = "22.05";
  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;
  hardware.enableRedistributableFirmware = true;

  services.journald.extraConfig = ''
    Storage=volatile
  '';

  networking.wireless.enable = true;
  networking.firewall = {
    allowedUDPPorts = [ 22 ];
    allowedTCPPorts = [ 22 ];
  };

  documentation.enable = false;
  documentation.man.generateCaches = lib.mkForce false;
}

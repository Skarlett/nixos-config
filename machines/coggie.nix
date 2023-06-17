{ keys, pkgs, config, lib, ... }: 
{
  boot.kernelPackages = pkgs.linux_rpi3;

  system.stateVersion = "22.11";
  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  services.journald.extraConfig = ''
    Storage=volatile
  '';

  hardware.enableRedistributableFirmware = true;
  networking.wireless.enable = true;
  networking.firewall = {
    allowedUDPPorts = [ 22 ];
    allowedTCPPorts = [ 22 ];
  };

  documentation.enable = false;
  documentation.man.generateCaches = lib.mkForce false;
}

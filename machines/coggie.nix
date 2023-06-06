{ keys, pkgs, config, lib, ... }: 
{
  documentation.enable = false;
  
  system.stateVersion = "22.11";  
  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;
  services.journald.extraConfig = ''
    Storage=volatile
  '';

  hardware.enableRedistributableFirmware = true;
  networking.wireless.enable = true;
  services.openssh.enable = true;
  networking.firewall = {
    allowedUDPPorts = [ 22 ];
    allowedTCPPorts = [ 22 ];
  };

  nix.settings.trusted-public-keys = [
    keys.flagship.store
  ]; 




  documentation.man.generateCaches = lib.mkForce false;
}

{ peers, pkgs, config, lib, ... }:
{
  boot.kernelPackages = pkgs.linuxPackages_rpi3;

  common.enable = true;
  common.headless = true;

  services.lvm.enable = false;
  system.stateVersion = "22.05";

  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;
  hardware.enableRedistributableFirmware = true;
  networking.wireless.enable = true; # needs to be enabled
  # for other chipsets to work

  networking.firewall.allowedUDPPorts = [ 51820 ];
  networking.wg-quick.interfaces.luni = {
    address = ["fd01:1:a1:1::5" "10.92.0.5"];
    privateKeyFile = "/etc/nixos/keys/wireguard/6/lunarix.pem";
    listenPort = 51820;
    peers = peers.gateways;
  };

  services.journald.extraConfig = ''
    Storage=volatile
  '';

  # programs.ssh.kexAlgorithms = [
  #   "diffie-hellman-group-exchange-sha1@10.0.0.153"
  # ];

  documentation.enable = false;
  documentation.man.generateCaches = lib.mkForce false;
}

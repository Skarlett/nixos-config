{config, pkgs, lib, peers, ...}:
{
  boot.kernelPackages = pkgs.linuxPackages_4_19;
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sde";

  networking.luninet.enable = true;
  networking.luninet.suffix = "::2";
  networking.luninet.peers = peers.gateways;

  common.enable = true;
  nixpkgs.config.allowUnfree = true;

  services.hydra = {
    enable = true;
    hydraURL = "http://localhost:3000";
    notificationSender = "hydra@localhost";
    buildMachinesFiles = [];
    useSubstitutes = true;
  };


  networking.firewall.allowedTCPPorts = [ 80 3000 443 ];

  gaming.project-zomboid-server.enable = true;
  gaming.project-zomboid-server.netfaces = ["luni" "enp4s0f0"];



  networking.hostName = "charmander";
  services.openssh.enable = true;
}

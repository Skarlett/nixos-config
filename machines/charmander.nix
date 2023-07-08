{config, pkgs, lib, ...}:
{
  boot.kernelPackages = pkgs.linuxPackages_4_19;
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sde";
  networking.lunihost.enable = true;
  networking.lunihost.suffix = ":ff01";

  services.hydra = {
    enable = true;
    hydraURL = "http://localhost:3000";
    notificationSender = "hydra@localhost";
    buildMachinesFiles = [];
    useSubstitutes = true;
  };
  networking.firewall.allowedTCPPorts = [ 80 3000 443 ];


  networking.hostName = "charmander";
  services.openssh.enable = true;
}

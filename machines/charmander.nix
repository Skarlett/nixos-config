{config, pkgs, lib, ...}:
{
  boot.kernelPackages = pkgs.linuxPackages_4_19;
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sde";
  networking.lunihost.enable = true;
  networking.lunihost.suffix = ":ff01";

  services.hydra = {
    enable = true;

    hydraURL = "http://localhost:3000"; # externally visible URL
    notificationSender = "hydra@localhost"; # e-mail of hydra service
    # a standalone hydra will require you to unset the
    # buildMachinesFiles list to avoid using a nonexistant /etc/nix/machines
    buildMachinesFiles = [];
    # you will probably also want, otherwise *everything* will be built from scratch
    useSubstitutes = true;
  };


  networking.hostName = "charmander";
  services.openssh.enable = true;
}

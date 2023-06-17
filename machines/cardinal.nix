{config, lib, pkgs, ...}:
let
  unalloc-root = "/srv/www/vhosts/unallocatedspace.dev";
  webroot = "/srv/www";
in
{
  boot.kernelPackages = pkgs.linuxPackages_5_10_hardened;
  boot.loader.grub = {
    enable = true;
    device = "/dev/vda";
    efiSupport = false;
    enableCryptodisk = true;
  };

  networking.hostName = "unallocatedspace";
  # networking.nat.externalInterface = "eth0";
  # networking.luninet.enable = true;
  # networking.luninet.subnet = ":ffff";
  # networking.luninet.suffix = "::ff00";

  # services.clamav.daemon.enable = true;
  # services.clamav.updater.enable = true;
  # services.journald.extraConfig = ''
  #   [Upload]
  #   URL=https://${FQDN}
  #   ServerKeyFile=;6u/etc/letsencrypt/live/client.your_domain/privkey.pem
  #   ServerCertificateFile=/etc/letsencrypt/live/client.your_domain/fullchain.pem
  #   TrustedCertificateFile=/etc/letsencrypt/live/client.your_domain/letsencrypt-combined-certs.pem
  # '';
}

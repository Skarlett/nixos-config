{config, lib, pkgs, peers, ...}:
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

  networking.lunihost.enable = true;
  networking.lunihost.suffix = "::ff00";
  networking.lunihost.peers = peers.users ++ peers.gateways;
  services.coggiebot.enable = true;
  services.coggiebot.environmentFile = "/var/lib/coggiebot/env.sh";

  # services.journald.extraConfig = ''
  #   [Upload]
  #   URL=https://${FQDN}
  #   ServerKeyFile=;6u/etc/letsencrypt/live/client.your_domain/privkey.pem
  #   ServerCertificateFile=/etc/letsencrypt/live/client.your_domain/fullchain.pem
  #   TrustedCertificateFile=/etc/letsencrypt/live/client.your_domain/letsencrypt-combined-certs.pem
  # '';
}

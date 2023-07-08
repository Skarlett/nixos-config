{config, lib, pkgs, peers, ...}:
{
  boot.kernelPackages = pkgs.linuxPackages_5_10_hardened;
  boot.loader.grub = {
    enable = true;
    device = "/dev/vda";
    efiSupport = false;
  };

  networking.hostName = "unallocatedspace";
  services.openssh.settings.PasswordAuthentication = false;

  networking.lunihost.enable = true;
  networking.lunihost.suffix = "::ff00";
  networking.lunihost.peers = peers.users ++ peers.gateways;
  services.coggiebot.enable = true;
  services.coggiebot.environmentFile = "/var/lib/coggiebot/env.sh";

  boot.kernel.sysctl."vm.swappiness" = 30;

  services.fail2ban.enable = true;
  services.fail2ban.bantime = "20m";
  services.fail2ban.bantime-increment.enable = true;
  services.openssh.logLevel = "VERBOSE";

  # services.journald.extraConfig = ''
  #   [Upload]
  #   URL=https://${FQDN}
  #   ServerKeyFile=;6u/etc/letsencrypt/live/client.your_domain/privkey.pem
  #   ServerCertificateFile=/etc/letsencrypt/live/client.your_domain/fullchain.pem
  #   TrustedCertificateFile=/etc/letsencrypt/live/client.your_domain/letsencrypt-combined-certs.pem
  # '';
}

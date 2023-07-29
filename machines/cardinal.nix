{config, lib, pkgs, ...}:
{
  boot.kernel.sysctl."vm.swappiness" = 80;

  common.enable = true;
  remote-access.lunarix = true;
  luninet.enable = true;

  boot.kernelPackages = pkgs.linuxPackages_5_10_hardened;
  boot.loader.grub = {
    enable = true;
    device = "/dev/vda";
    efiSupport = false;
  };

  networking.hostName = "unallocatedspace";
  services.unallocatedspace.enable = true;

  services.coggiebot.enable = true;
  services.coggiebot.environmentFile = "/var/lib/coggiebot/env.sh";

  services.fail2ban.enable = true;
  services.fail2ban.bantime = "20m";
  services.fail2ban.bantime-increment.enable = true;

  services.openssh.settings.LogLevel = "VERBOSE";
  services.openssh.settings.PasswordAuthentication = false;

  # services.journald.extraConfig = ''
  #   [Upload]
  #   URL=https://${FQDN}
  #   ServerKeyFile=;6u/etc/letsencrypt/live/client.your_domain/privkey.pem
  #   ServerCertificateFile=/etc/letsencrypt/live/client.your_domain/fullchain.pem
  #   TrustedCertificateFile=/etc/letsencrypt/live/client.your_domain/letsencrypt-combined-certs.pem
  # '';
}

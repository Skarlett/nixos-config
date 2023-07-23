{config, lib, pkgs, peers, ...}:
{
  common.enable = true;
  remote-access.lunarix = true;

  boot.kernelPackages = pkgs.linuxPackages_5_10_hardened;
  boot.loader.grub = {
    enable = true;
    device = "/dev/vda";
    efiSupport = false;
  };

  networking.hostName = "unallocatedspace";
  services.unallocatedspace.enable = true;

  boot.kernel.sysctl."net.ipv6.conf.luna.ip_forward" = 1;
  boot.kernel.sysctl."net.ipv4.conf.luna.ip_forward" = 1;

  networking.nat.enable = true;
  networking.nat.externalInterface = "ens3";
  networking.nat.internalInterfaces = [ "luni" ];

  networking.firewall.allowedUDPPorts = [51820];
  # fd01:8cae:d246:5f03:XXXX:XXXX:XXXX:XXXX
  #  16    32   48   64   80   96  112  128
  networking.wireguard.interfaces.luni =
    {
      postSetup = ''
          ${pkgs.iptables}/bin/ip6tables -A FORWARD -i luni -j ACCEPT
          ${pkgs.iptables}/bin/ip6tables -t nat -A POSTROUTING -o luni -j MASQUERADE
          ${pkgs.iptables}/bin/iptables -A FORWARD -i luni -j ACCEPT
          ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -o luni -j MASQUERADE
      '';
      postShutdown = ''
          ${pkgs.iptables}/bin/ip6tables -D FORWARD -i luni -j ACCEPT
          ${pkgs.iptables}/bin/ip6tables -t nat -D POSTROUTING -o luni -j MASQUERADE
          ${pkgs.iptables}/bin/iptables -D FORWARD -i luni -j ACCEPT
          ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -o luni -j MASQUERADE
      '';
      peers = with peers; (users ++ gateways);
      ips = ["fd01:1:a1::ff00/48" "10.51.0.128/24"];
      listenPort = 51820;
      privateKeyFile = "/var/lib/wireguard/privatekey";
    };

  services.coggiebot.enable = true;
  services.coggiebot.environmentFile = "/var/lib/coggiebot/env.sh";

  boot.kernel.sysctl."vm.swappiness" = 80;
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

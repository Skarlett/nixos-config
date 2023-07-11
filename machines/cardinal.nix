{config, lib, pkgs, peers, ...}:
{
  common.enable = true;
  boot.kernelPackages = pkgs.linuxPackages_5_10_hardened;
  boot.loader.grub = {
    enable = true;
    device = "/dev/vda";
    efiSupport = false;
  };

  networking.hostName = "unallocatedspace";
  services.openssh.settings.PasswordAuthentication = false;



  networking.firewall = {
      allowedUDPPorts = [
        51820
      ];
    };

  boot.kernel.sysctl."net.ipv6.conf.luna6.ip_forward" = 1;
  boot.kernel.sysctl."net.ipv4.conf.luna4.ip_forward" = 1;

  # fd01:8cae:d246:5f03:XXXX:XXXX:XXXX:XXXX
  #  16    32   48   64   80   96  112  128
  networking.wireguard.interfaces.luni6 =
    {
      postSetup = ''
         ${pkgs.iptables}/bin/ip6tables -A FORWARD -i luni6 -j ACCEPT
         ${pkgs.iptables}/bin/ip6tables -t nat -A POSTROUTING -o luni6 -j MASQUERADE
      '';

      postShutdown = ''
         ${pkgs.iptables}/bin/ip6tables -D FORWARD -i luni6 -j ACCEPT
         ${pkgs.iptables}/bin/ip6tables -t nat -D POSTROUTING -o luni6 -j MASQUERADE
      '';

      peers = with peers; prot-ip ipv6 (users ++ gateways);
      ips = ["fd01:1:a1::ff00/48"];
      listenPort = 51820;
      privateKeyFile = "/var/lib/wireguard/privatekey";
    };

  # fd01:8cae:d246:5f03:XXXX:XXXX:XXXX:XXXX
  #  16    32   48   64   80   96  112  128
  networking.wireguard.interfaces.luni4 =
    {
      # postSetup = ''
      #    ${pkgs.iptables}/bin/iptables -A FORWARD -i luni4 -j ACCEPT
      #    ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -o luni4 -j MASQUERADE
      # '';

      # postShutdown = ''
      #    ${pkgs.iptables}/bin/iptables -D FORWARD -i luni4 -j ACCEPT
      #    ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -o luni4 -j MASQUERADE
      # '';

      peers = with peers; prot-ip ipv4 (users ++ gateways);
      ips = ["10.51.0.255/24"];
      listenPort = 51821;
      privateKeyFile = "/var/lib/wireguard/ipv4-privatekey";
    };

  services.coggiebot.enable = true;
  services.coggiebot.environmentFile = "/var/lib/coggiebot/env.sh";

  boot.kernel.sysctl."vm.swappiness" = 30;

  services.fail2ban.enable = true;
  services.fail2ban.bantime = "20m";
  services.fail2ban.bantime-increment.enable = true;
  services.openssh.logLevel = "VERBOSE";

    # networking.postUpCommands =
    #   ''
    #   ip6tables -t nat -A PREROUTING -p udp --dport 16262 -j DNAT --to-destination :16262
    #   ip6tables -t nat -A POSTROUTING -p udp -d fd01:1:a1:1::2 --dport 16262 -j SNAT --to-source 192.168.12.87

    #   ip6tables -t nat -A PREROUTING -p udp --dport 16261 -j DNAT --to-destination [fd01:1:a1:1::2]:16262
    #   ip6tables -t nat -A POSTROUTING -p udp -d fd01:1:a1:1::2 --dport 16261 -j SNAT --to-source 192.168.12.87

    #   ip6tables -t nat -A PREROUTING -p tcp --dport 2232 -j DNAT --to-destination [fd01:1:a1:1::2]:22
    #   '';




  # services.journald.extraConfig = ''
  #   [Upload]
  #   URL=https://${FQDN}
  #   ServerKeyFile=;6u/etc/letsencrypt/live/client.your_domain/privkey.pem
  #   ServerCertificateFile=/etc/letsencrypt/live/client.your_domain/fullchain.pem
  #   TrustedCertificateFile=/etc/letsencrypt/live/client.your_domain/letsencrypt-combined-certs.pem
  # '';
}

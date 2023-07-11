{config, pkgs, lib, peers, ...}:
{
  boot.kernelPackages = pkgs.linuxPackages_4_19;
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sde";

  networking.firewall.allowedUDPPorts = [ 51820 51821 16261 16262];

  networking.wg-quick.interfaces.luni6 = {
    address = ["fd01:1:a1:1::2"];
    privateKeyFile = "/var/lib/wireguard/privatekey";
    listenPort = 51820;
    peers = with peers; prot-ip ipv6 gateways;
  };

  networking.wg-quick.interfaces.luni4 = {
    address = ["10.51.0.2"];
    privateKeyFile = "/var/lib/wireguard/ipv4-privatekey";
    listenPort = 51821;
    peers = with peers; lib.traceValSeqN 2 (prot-ip ipv4 gateways);
  };

 #  # networking.luninet.enable = true;
 #  # networking.luninet.suffix = "::2";
 #  # networking.luninet.peers = peers.gateways ++ [
 #  #   peers.peers.lunarix.desktop
 #  # ];
 # # https://superuser.com/questions/1776851/routing-wireguard-peers-traffic-via-another-peer
 #  systemd.network = {
 #    enable = true;
 #    netdevs = {
 #      "10-luni" = {
 #        netdevConfig = {
 #          Kind = "wireguard";
 #          Name = "luni";
 #          MTUBytes = "1400";
 #        };

 #        # See also man systemd.netdev (also contains info on the permissions of the key files)
 #        wireguardConfig = {
 #          # Don't use a file from the Nix store as these are world readable.
 #          PrivateKeyFile = "/var/lib/wireguard/privatekey";
 #          ListenPort = 51820;
 #        };

 #        wireguardPeers = [
 #            { wireguardPeerConfig =
 #              {
 #                AllowedIPs = ["::/0"];
 #                PublicKey = "LIP2yM8DbX563oRbtDGn1WxzPiBXUP6tCLbcnXXUOz4=";
 #                Endpoint = "172.245.82.235:51820";
 #              };
 #              }
 #          ];
 #      };
 #    };

 #    networks.luni6 = {
 #      # See also man systemd.network
 #      matchConfig.Name = "luni";
 #      # routes = [{
 #      #   routeOptions = {
 #      #     Destination = "fd01:1:a1::/48";
 #      #     Gateway = "fd01:1:a1:ff00";
 #      # };}];
 #      # IP addresses the client interface will have
 #      address = [
 #        "fd01:1:a1:1::2"
 #      ];
 #      DHCP = "no";
 #      # dns = [ "fc00::53" ];
 #      # ntp = [ "fc00::123" ];
 #      gateway = [
 #        "fd01:1:a1:ff00"
 #      ];
 #      networkConfig = {
 #        IPv6AcceptRA = false;
 #      };
 #    };
 #  };

  environment.systemPackages = [ pkgs.wireguard-tools ];

  # networking.wg-quick.interfaces.luni = {
  #   # postSetup = ''
  #   #   ip -6 rule add fwmark 0x123 lookup 200
  #   #   ip -6 rule add from fd01:1:a1::/48 lookup 200
  #   #   ip -6 route add fd01:1:a1::/48 dev luni table 200
  #   # '';

  #   # postShutdown = ''
  #   #   ip -6 route flush table 200
  #   #   ip -6 rule del from fd01:1:a1::/48 lookup 200
  #   #   ip -6 route del fd01:1:a1::/48 dev luni table 200
  #   # '';

  #   # table = "200";
  #   # fwMark = "0x123";

  #   address = [ "fd01:1:a1:1::2" ];
  #   privateKeyFile = "/var/lib/wireguard/privatekey";
  #   listenPort = 51820;
  #   peers =  peers.gateways ++ [
  #     peers.peers.lunarix.desktop
  #   ];
  # };

  boot.kernel.sysctl."net.ipv6.conf.all.ip_forward" = 1;

  common.enable = true;
  nixpkgs.config.allowUnfree = true;

  services.hydra = {
    enable = true;
    hydraURL = "http://localhost:3000";
    notificationSender = "hydra@localhost";
    buildMachinesFiles = [];
    useSubstitutes = true;
  };


  networking.firewall.allowedTCPPorts = [ 80 3000 443 16261 16262 2232 ];

  gaming.project-zomboid-server.enable = true;
  gaming.project-zomboid-server.netfaces = ["luni" "enp4s0f0"];



  networking.hostName = "charmander";
  services.openssh.enable = true;
}

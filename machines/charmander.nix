{config, pkgs, lib, ...}:
{
  common.enable = true;
  remote-access.lunarix = true;
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = [ pkgs.wireguard-tools ];
  # services.airsonic-advanced.enable = true;
  # services.airsonic-advanced.openFirewall = true;

  # services.gitea.enable = true;
  # services.nginx.enable = true;
  # services.minecraft-server = {
  #   enable = true;
  #   eula = true;
  #   declarative = true;
  # };

  # services.rpcbind.enable = true;
  # services.nfs.server = {
  #   enable = true;
  #   createMountPoints = false;
  #   lockdPort = 4001;
  #   mountdPort = 4002;
  #   statdPort = 4000;
  #   exports = ''
  #   /export           10.0.0.0/24(r,fsid=0,no_subtree_check)
  #   /export/cardinal  10.0.0.0/24(rw,nohide,insecure,no_subtree_check,async) 10.51.0.128/32(rw,nohide,insecure,no_subtree_check,async)
  #   '';

  #   # ''
  #   # /export/music     10.0.0.0/24(rw,nohide,insecure,no_subtree_check,async) 10.51.0.0/24(rw,nohide,insecure,no_subtree_check,async)
  #   # '';
  # }
  # ;

  # systemd.tmpfiles.rules = [
  #   "d /export 0111 nobody nogroup -"
  #   "d /export/cardinal 0550 lunarix cardinaladm -"

  #   "d /export/music 0051 nobody musicmod -"
  #   "d /export/music/lunarix 0511 lunarix musicmod -"
  #   "d /export/music/alex 0511 cardinal musicmod -"

  #   "t /run/pzsocks 0777 nobody nobody -"
  #   "t /run/minecraft-socks 0777 nobody nobody -"


  #   "d /srv 0551 nobody nogroup -"
  #   "L /var/lib/minecraft-server /srv/minecraft-server"
  # ];

  networking.firewall.allowedUDPPorts = [
    51820

    16261 16262

    111 2049 4000 4001 4002 20048
    # 53
  ];

  networking.firewall.interfaces.luni.allowedUDPPorts = [
    # Project zomboid
    16261 16262

    # NFS
    111 2049 4000 4001 4002 20048
  ];

  networking.firewall.allowedTCPPorts = [
    16261 16262 2232
    80 3000 443 22

    111 2049 4000 4001 4002 20048
    # 53
  ];

  networking.wireguard.interfaces.luni = {
    ips = [
      "fd01:1:a1:1::2"
      "10.51.0.2"
      # "10.51.1.2"
    ];

    privateKeyFile = "/var/lib/wireguard/privatekey";
    listenPort = 51820;
    peers = config.luninet.gateways;
    postSetup = ''
      ${pkgs.iproute2}/bin/ip route add fd01:1:a1::/48 dev luni
      ${pkgs.iproute2}/bin/ip route add 10.51.0.0/24 dev luni
    '';
    postShutdown = ''
      ${pkgs.iproute2}/bin/ip route del fd01:1:a1::/48 dev luni
      ${pkgs.iproute2}/bin/ip route del 10.51.0.0/24 dev luni
    '';
  };

  boot.kernel.sysctl."net.ipv6.conf.luna.ip_forward" = 1;
  boot.kernel.sysctl."net.ipv4.conf.luna.ip_forward" = 1;

  services.hydra = {
    enable = true;
    hydraURL = "http://localhost:3000";
    notificationSender = "hydra@localhost";
    buildMachinesFiles = [];
    useSubstitutes = true;
  };

  gaming.project-zomboid-server.enable = true;

  networking.hostName = "charmander";

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sde";

  system.stateVersion = "23.05";
}

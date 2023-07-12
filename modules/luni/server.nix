{config, pkgs, lib, ... }:
with lib;
let
  cfg = config.networking.lunihost;
in
{
  options.networking.lunihost =
  {
    enable = mkEnableOption "host luni net";
    network = mkOption {
      type = types.string;
      default = "fd01:1:a1";
    };

    subnet = mkOption {
      type = types.string;
      default = "";
    };

    suffix = mkOption {
      type = types.string;
    };

    netmask = mkOption {
      default = "48";
    };

    ips = mkOption {
      type = types.listOf types.string;
      default = [ "${cfg.network}${cfg.subnet}${cfg.suffix}/${cfg.netmask}" ];
    };

    privateKeyFile = mkOption {
      type = types.path;
      default = "/var/lib/wireguard/privatekey";
    };

    peers = mkOption {
      default = [];
    };

    device = mkOption {
      type = types.string;
      default = "luni";
    };

    port = mkOption {
      default = 51820;
    };
  };

  config = mkIf cfg.enable {
    # enable NAT
    # networking.nat.internalInterfaces = [ "wgluna" ];
    networking.firewall = {
      allowedUDPPorts = [ cfg.port ];
    };



    boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
    boot.kernel.sysctl."net.ipv6.conf.all.ip_forward" = 1;
    # fd01:8cae:d246:5f03:XXXX:XXXX:XXXX:XXXX
    #  16    32   48   64   80   96  112  128
    networking.wireguard.interfaces.${cfg.device} =
      {
            # postSetup = ''
            #       ${pkgs.iptables}/bin/ip6tables -A FORWARD -i luni -j ACCEPT
            #       ${pkgs.iptables}/bin/ip6tables -t nat -A POSTROUTING -s fdc9:281f:04d7:9ee9::1/64 -o eth0 -j MASQUERADE
            #       '';

            # postShutdown = ''
            # ${pkgs.iptables}/bin/ip6tables -D FORWARD -i wg0 -j ACCEPT
            # ${pkgs.iptables}/bin/ip6tables -t nat -D POSTROUTING -s fdc9:281f:04d7:9ee9::1/64 -o eth0 -j MASQUERADE
            # '';



        peers = cfg.peers;
        ips = cfg.ips;
        listenPort = cfg.port;
        privateKeyFile = cfg.privateKeyFile;
    };
  };
}

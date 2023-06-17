{config, pkgs, lib, keys, ... }:
with lib;
let
  netmap = pkgs.callPackage ./peers.nix { inherit keys; };
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
      default = netmap.gateways ++ netmap.users;
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

    boot.kernel.sysctl."net.ipv6.ip_forward" = 1;
    # fd01:8cae:d246:5f03:XXXX:XXXX:XXXX:XXXX
    #  16    32   48   64   80   96  112  128
    networking.wireguard.interfaces.${cfg.device} =
      let
        peers = (import ./peers.nix { inherit keys lib; });
      in
      {
        peers = cfg.peers;
        ips = cfg.ips;
        listenPort = cfg.port;
        privateKeyFile = cfg.privateKeyFile;
    };
  };
}

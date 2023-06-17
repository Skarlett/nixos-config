{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.networking.luninet;
in
{
  options.networking.luninet = {
    enable = mkEnableOption "enable vpn into loonie-net";

    network = mkOption {
      type = types.string;
      default = "fd01:1:a1";
    };

    subnet = mkOption {
      type = types.string;
      default = ":1";
    };

    suffix = mkOption {
      type = types.string;
    };

    address = mkOption {
      type = types.listOf types.string;
      default = [ "${cfg.network}${cfg.subnet}${cfg.suffix}" ];
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
    networking.firewall.allowedUDPPorts = [ 51820 ];
    networking.wg-quick.interfaces.${cfg.device} = {
      address = cfg.address;
      privateKeyFile = cfg.privateKeyFile;
      listenPort = 51820;
      peers = cfg.peers;
    };
  };
}

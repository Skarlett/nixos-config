{config, pkgs, lib, keys, ... }:
{
  # enable NAT
  # networking.nat.internalInterfaces = [ "wgluna" ];
  networking.firewall = {
    allowedUDPPorts = [ 51820 ];
  };

  boot.kernel.sysctl."net.ipv6.ip_forward" = 1;
  # fd01:8cae:d246:5f03:XXXX:XXXX:XXXX:XXXX
  #  16    32   48   64   80   96  112  128
  networking.wireguard.interfaces.wgluni =
    let
      network-cidr = "fd01:1:a1::ffff/48";
      peers = pkgs.lib.traceValSeqN 2 (import ./peers.nix { inherit keys lib; });
    in
    {
      peers = [ peers.peers.lunarix.desktop ];
      ips = [ network-cidr ];
      listenPort = 51820;
      privateKeyFile = "/var/lib/wireguard/privatekey";
   };
}

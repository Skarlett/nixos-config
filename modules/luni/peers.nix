{lib, keys }:
let
  # Entire network: fd01:1:1::/48
  peers = {
    lunarix = {
      desktop = {
        publicKey = keys.flagship.wgk;
        allowedIPs = [ "fd01:1:a1:1::1/64" ];
      };

      coggie = {
        publicKey = keys.coggie.wireguard;
        allowedIPs = [ "fd01:1:1:a1:1::2/64" ];
      };

      # charmander = {
      #   publicKey = keys.cardinal.wireguard;
      #   allowedIPs = ["::/0"];
      #   endpoint = "10.0.0.2:51820";
      # };

      cardinal = {
        publicKey = keys.cardinal.wireguard;
        allowedIPs = ["::/0"];
        endpoint = "unallocatedspace.dev:51820";
      };
    };

    # jeff
    jeff.gateway = {
      publicKey = keys.coggie.wireguard;
      allowedIPs = [ "fd01:1:1:a1:420::1/64" ];
    };

    # dan
    dan.gateway = {
      publicKey = keys.coggie.wireguard;
      allowedIPs = [ "fd01:1:1:a1:ffe::1/64" ];
    };
  };

  gateways = with peers; [
    lunarix.cardinal
    # lunarix.charmander
  ];

  users = with peers; [
    lunarix.desktop

  ];
in
{
    inherit peers gateways users;
    all = (lib.flatten (builtins.attrValues peers));
}

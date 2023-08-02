{config, lib, pkgs, ...}:
let
  # Entire network: fd01:1:1::/48
  peers =
  {
    lunarix = {
      # ip route add fd01:1:1::/48 dev luni
      desktop = {
        publicKey = "pZZcZFL6ejkYlcfIXe06AkALIcbTGBtIAjxGT0LfZ1g=";
        allowedIPs = ["fd01:1:a1:1::1/128" "10.51.0.1/32"];
        persistentKeepalive = 25;
      };

      charmander = {
        publicKey = "8Mf/gY7KnLl3rTQKN5I7fJIUJ6fEzBwget3YyRwM61Y=";
        allowedIPs = ["fd01:1:a1:1::2/128" "10.51.0.2/32"];
        persistentKeepalive = 25;
      };

      cardinal = {
        publicKey = "LIP2yM8DbX563oRbtDGn1WxzPiBXUP6tCLbcnXXUOz4=";
        allowedIPs = ["fd01:1:a1::/48" "10.51.0.0/24"];
        endpoint = "172.245.82.235:51820";
      };
    };

        # # dan
    dan.gateway = {
      publicKey = "fANz8f8OOU4Pe95QeZGEBiqnvN35I9n5IvCVEbqZKFo=";
      allowedIPs = [
        "fd01:1:a1:ffe::1/128"
        "10.51.0.3/32"
      ];
      persistentKeepalive = 25;
    };
  };

  physcedelic.gateway = {
    publicKey = "NthEU9Lldx3V+UDvudt4wGR4qE6fxjyacDMidrcxa2Y=";
      allowedIPs = [
        "fd01:1:a1:e::1/128"
        "10.51.0.4/32"
      ];
      persistentKeepalive = 25;
  };

  snordalf.gateway = {
    publicKey = "S6yiCMatKlVX0WxyaWXTizasZPfQQ9oGM2pv82CtrgM=";
    allowedIPs = [
        "fd01:1:a1:f::1/128"
        "10.51.0.5"
    ];
    persistentKeepalive = 25;
  };

  t3mpt0n.desktop = {
    publicKey = "bwvU8oStrpW5oPd10hoORwbtawwm0Dxf2IklgNCtz0M=";
    allowedIPs = ["fd01:1:a1:ee::1" "10.51.0.12"];
  };

  zach.desktop = {
    publicKey = "ukg+dd04c+vgAlb4ujz8w2Dv7heQZ6mmwEYtDMFgIkw=";
    allowedIPs = ["fd01:1:a1:216::1" "10.51.0.7"];
    persistentKeepalive = 25;
  };

  # noita = {
  #   publicKey = "OnU7dgZ6vntnaojgooaQt8hLPn/dkpqKQID/pXYa/CI=";
  #   allowedIPs = ["fd01:1:a1:f1::1/64" "fd01:1:a1:1::1/64"];
  # };

  heccin.desktop = {
    publicKey = "D+rNqpJ8RSaflldKRhWb8Q/p7Cox+Y/mLdUJUcjsyTs=";
    allowedIPs = ["fd01:1:a1:23f::1/128" "10.51.0.13/32"];
    persistentKeepalive = 25;
  };

  conic.desktop = {
    publicKey = "tuBigIORaghdhaEZd+h9ELeZWthQtEjEewaBcIXb5y8=";
    allowedIPs = ["fd01:1:a1:23e::1/128" "10.51.0.14/32"];
    persistentKeepalive = 25;
  };

  k10.desktop = {
    publicKey = "bVMpoVy4nSiCX5skVtD3oOFaL0DJKMvxNB5XMIpjbg4=";
    allowedIPs = ["fd01:1:a1:14f::1/128" "10.51.0.15/32"];
    persistentKeepalive = 25;
  };

  jeff.desktop = {
    publicKey = "NdVu+FGhasvUQqCartAXe7B1MinlIhspVqvKxFEoKi8=";
    allowedIPs = ["fd01:1:a1:69::1/128" "10.51.0.16/32"];
    persistentKeepalive = 25;
  };

  simcra.desktop = {
    publicKey = "iKKn0hxQdScrXXkpmIC83Zgo0Y3GexCQ4+Qd/6NryUc=";
    allowedIPs = ["fd01:1:a1:24f::1/128" "10.51.0.25/32"];
    persistentKeepalive = 25;
  };

  gateways = with peers; [
    lunarix.cardinal
  ];

  users = with peers; [
    lunarix.desktop
    lunarix.charmander
    dan.gateway
    physcedelic.gateway
    snordalf.gateway
    zach.desktop
    t3mpt0n.desktop
    conic.desktop
    heccin.desktop
    simcra.desktop
    k10.desktop
    jeff.desktop
  ];

  cfg = config.luninet;
in
with lib;
{

  options.luninet = {
    enable = mkEnableOption "luninet";

    users = mkOption {
      # type = types.listOf types.submodule (config.networking.wireguard.peers);
      default = peers;
    };

    gateways = mkOption {
      # type = types.listOf types.submodule (config.networking.wireguard.peers);
      default = gateways;
    };

     port = mkOption {
      type = types.int.port;
      default = gateways;
    };

     extraPostSetup = mkOption {
       # doc = "Extra commands to run after setting up the wireguard interface. extends
       # `config.networking.wireguard.interfaces.luni.postSetup`";
       default = "";
     };

     extraPostShutdown = mkOption {
       # doc = "Extra commands to run after setting up the wireguard interface. extends
       #  `config.networking.wireguard.interfaces.luni.postShutdown`";
       default = "";
     };

     openFirewall = mkEnableOption "openFirewall";

     externalInterface = mkOption {
       type = types.str;
     };

     internalInterfaces = mkOption {
       type = types.str;
       default = "luni";
     };
  };

  config = mkIf cfg.enable {
    boot.kernel.sysctl."net.ipv6.conf.luna.ip_forward" = 1;
    boot.kernel.sysctl."net.ipv4.conf.luna.ip_forward" = 1;
    networking = {
      nat.enable = true;
      nat.externalInterface = "ens3";
      nat.internalInterfaces = [ "luni" ];

      firewall.allowedUDPPorts = lib.optional cfg.openFirewall [
        51820
      ];

      # TODO: mp bpg, evpn, vxlan, over wireguard
      wireguard.interfaces.luni = {
        postSetup = ''
            ${pkgs.iptables}/bin/ip6tables -A FORWARD -i luni -j ACCEPT
            ${pkgs.iptables}/bin/ip6tables -t nat -A POSTROUTING -o luni -j MASQUERADE
            ${pkgs.iptables}/bin/iptables -A FORWARD -i luni -j ACCEPT
            ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -o luni -j MASQUERADE

            ${cfg.extraPostSetup}
        '';
        postShutdown = ''
            ${pkgs.iptables}/bin/ip6tables -D FORWARD -i luni -j ACCEPT
            ${pkgs.iptables}/bin/ip6tables -t nat -D POSTROUTING -o luni -j MASQUERADE
            ${pkgs.iptables}/bin/iptables -D FORWARD -i luni -j ACCEPT
            ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -o luni -j MASQUERADE

            ${cfg.extraPostShutdown}
        '';
        peers = with peers; (users ++ gateways);
        ips = ["fd01:1:a1::ff00/48" "10.51.0.128/24"];
        listenPort = 51820;
        privateKeyFile = "/var/lib/wireguard/privatekey";
      };
    };
  };
}

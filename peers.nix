{lib, keys }:
let

  # Entire network: fd01:1:1::/48
  peers =
  {
    lunarix = {
      #
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
      # publicKey.v4 = "mqT87yQ0i7dki5pQrUAStRxYLcG9ipvaCbP76mkDhTI=";
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

  conic.desktop = {
    publicKey = "tuBigIORaghdhaEZd+h9ELeZWthQtEjEewaBcIXb5y8=";
    allowedIPs = ["fd01:1:a1:23e::1/128" "10.51.0.14/32"];
    persistentKeepalive = 25;
  };

  heccin.desktop = {
    publicKey = "D+rNqpJ8RSaflldKRhWb8Q/p7Cox+Y/mLdUJUcjsyTs=";
    allowedIPs = ["fd01:1:a1:23f::1/128" "10.51.0.13/32"];
    persistentKeepalive = 25;
  };

  simcra.desktop = {
    publicKey = "iKKn0hxQdScrXXkpmIC83Zgo0Y3GexCQ4+Qd/6NryUc=";
    allowedIPs = ["fd01:1:a1:24f::1/128" "10.51.0.25/32"];
    persistentKeepalive = 25;
  };

  jeff.desktop = {
    publicKey = "NdVu+FGhasvUQqCartAXe7B1MinlIhspVqvKxFEoKi8=";
    allowedIPs = [
      "fd01:1:a1:69::1"
      "10.51.0.16"
    ];
    persistentKeepalive = 25;
  };

  k10.desktop = {
    publicKey = "bVMpoVy4nSiCX5skVtD3oOFaL0DJKMvxNB5XMIpjbg4=";
    allowedIPs = ["fd01:1:a1:14f::1/128" "10.51.0.15/32"];
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

in
{
  inherit peers gateways users;
}

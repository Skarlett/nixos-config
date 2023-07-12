{lib, keys }:
let

  # Entire network: fd01:1:1::/48
  peers =
  {
    lunarix = {
      #
      # ip add route fd01:1:1::/48
      #   via fd01:1:1::ff00 dev luni
      # ip add route
      desktop = {
        # publicKey.v4 = "HDAevYnp9azFNQS0YRPyJv7Edsko37EQO+/UWhJBDEQ=";
        publicKey = "pZZcZFL6ejkYlcfIXe06AkALIcbTGBtIAjxGT0LfZ1g=";
        allowedIPs = ["fd01:1:a1:1::1/128" "10.51.0.1/32"];
        # allowedIPs.v4 = ["10.51.0.1/32"];
        persistentKeepalive = 25;
      };

      charmander = {
        # publicKey.v4 = "5CHKh5kh0sZrK0g7+hCwM3aVCls3mnsKd2PnruOL+FE=";
        publicKey = "8Mf/gY7KnLl3rTQKN5I7fJIUJ6fEzBwget3YyRwM61Y=";
        allowedIPs = ["fd01:1:a1:1::2/128" "10.51.0.2/32"];
        # allowedIPs.v4 = ["10.51.0.2/32"];
        persistentKeepalive = 25;
      };

      cardinal = {
        publicKey = "LIP2yM8DbX563oRbtDGn1WxzPiBXUP6tCLbcnXXUOz4=";
        # publicKey.v4 = "alDDI4srLjbl3eZN98OPq0NrfZZDe2/j2oBl0zHKDi4=";
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

  zach.desktop = {
    publicKey = "ukg+dd04c+vgAlb4ujz8w2Dv7heQZ6mmwEYtDMFgIkw=";
    allowedIPs = ["fd01:1:a1:216::1" "10.51.0.7"];
    persistentKeepalive = 25;
  };

  # noita = {
  #   publicKey = "OnU7dgZ6vntnaojgooaQt8hLPn/dkpqKQID/pXYa/CI=";
  #   allowedIPs = ["fd01:1:a1:f1::1/64" "fd01:1:a1:1::1/64"];
  # };

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
  ];

in
{
  ipv6 = u: u // { publicKey = u.publicKey.v6; allowedIPs = u.allowedIPs.v6; };
  ipv4 = u: u // { publicKey = u.publicKey.v4; allowedIPs = u.allowedIPs.v4; };
  prot-ip = f: l: map (s: s // f s) l;
  inherit peers gateways users;
}

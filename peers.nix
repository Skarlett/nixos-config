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
        publicKey.v4 = "alDDI4srLjbl3eZN98OPq0NrfZZDe2/j2oBl0zHKDi4=";
        publicKey.v6 = "pZZcZFL6ejkYlcfIXe06AkALIcbTGBtIAjxGT0LfZ1g=";
        allowedIPs.v6 = ["fd01:1:a1:1::1"];
        allowedIPs.v4 = ["10.51.0.1/32"];
      };

      charmander = {
        publicKey.v4 = "5CHKh5kh0sZrK0g7+hCwM3aVCls3mnsKd2PnruOL+FE=";
        publicKey.v6 = "8Mf/gY7KnLl3rTQKN5I7fJIUJ6fEzBwget3YyRwM61Y=";
        allowedIPs.v6 = ["fd01:1:a1:1::2"];
        allowedIPs.v4 = ["10.51.0.2/32"];
      };

      cardinal = {
        publicKey.v6 = "LIP2yM8DbX563oRbtDGn1WxzPiBXUP6tCLbcnXXUOz4=";
        publicKey.v4 = "alDDI4srLjbl3eZN98OPq0NrfZZDe2/j2oBl0zHKDi4=";
        allowedIPs.v6 = ["::/0"];
        allowedIPs.v4 = ["0.0.0.0/0"];
        endpoint = "172.245.82.235:51820";
      };
    };

        # # dan
    dan.gateway = {
      publicKey.v6 = "fANz8f8OOU4Pe95QeZGEBiqnvN35I9n5IvCVEbqZKFo=";
      publicKey.v4 = "mqT87yQ0i7dki5pQrUAStRxYLcG9ipvaCbP76mkDhTI=";
      allowedIPs.v6 = [
        "fd01:1:a1:ffe::1/128"
      ];
      allowedIPs.v4 = ["10.51.0.3/32"];
    };
  };

  # zach.desktop = {
  #   publicKey = "";
  #   allowedIPs = ["fd01:1:a1:1::216"];
  # };

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
  ];

in
{
  ipv6 = u: u // { publicKey = u.publicKey.v6; allowedIPs = u.allowedIPs.v6; };
  ipv4 = u: u // { publicKey = u.publicKey.v4; allowedIPs = u.allowedIPs.v4; };
  prot-ip = f: l: map (s: s // f s) l;
  inherit peers gateways users;
}

{lib, keys }:
let

  # Entire network: fd01:1:1::/48
  peers = {
    lunarix = {
      desktop = {
        publicKey = "pZZcZFL6ejkYlcfIXe06AkALIcbTGBtIAjxGT0LfZ1g=";
        allowedIPs = ["fd01:1:a1:1::1"];
      };

      charmander = {
        publicKey = "8Mf/gY7KnLl3rTQKN5I7fJIUJ6fEzBwget3YyRwM61Y=";
        allowedIPs = ["fd01:1:a1:1::2"];
      };

      cardinal = {
        publicKey = "LIP2yM8DbX563oRbtDGn1WxzPiBXUP6tCLbcnXXUOz4=";
        allowedIPs = ["::/0"];
        endpoint = "unallocatedspace.dev:51820";
      };
    };

    # # dan
    dan.gateway = {
      publicKey = "fANz8f8OOU4Pe95QeZGEBiqnvN35I9n5IvCVEbqZKFo=";
      allowedIPs = [
        "fd01:1:1:a1:ffe::1"
      ];
    };
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
  ];
in
{
    inherit peers gateways users;
}

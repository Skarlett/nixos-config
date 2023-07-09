{config, lib, pkgs, keys, ...}:
{
    services.openssh.enable = true;
    networking.firewall.allowedTCPPorts = [ 22 ];
    networking.firewall.allowedUDPPorts = [ 22 ];

    users.users.lunarix.openssh.authorizedKeys.keys = [ keys.flagship.lunarix.ssh ];
    users.users.root.openssh.authorizedKeys.keys = [ keys.flagship.lunarix.ssh ];

    nix.settings.trusted-public-keys = [
        keys.flagship.store
    ];
}

{config, lib, pkgs, keys, ...}:
{
    services.openssh.enable = true;

    users.users.lunarix.openssh.authorizedKeys.keys = [ keys.flagship.lunarix.ssh ];
    users.users.root.openssh.authorizedKeys.keys = [ keys.flagship.lunarix.ssh ];

    nix.settings.trusted-public-keys = [
        keys.flagship.store
    ];
}

{config, lib, pkgs, keys, ...}:
let
    cfg = config.remote-access;
in
{
    options.remote-access.lunarix = lib.mkEnableOption "give lunarix access";
    config = lib.mkIf cfg.lunarix {
        services.openssh.enable = true;
        services.openssh.ports = [ 22 ];

        networking.firewall.allowedTCPPorts = config.services.openssh.ports;
        networking.firewall.allowedUDPPorts = config.services.openssh.ports;

        users.users.lunarix.openssh.authorizedKeys.keys = [ keys.flagship.lunarix.ssh ];
        users.users.root.openssh.authorizedKeys.keys = [ keys.flagship.lunarix.ssh ];

        nix.settings.trusted-public-keys = [
            keys.flagship.store
        ];
    };
}

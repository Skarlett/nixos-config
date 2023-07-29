{config, lib, pkgs, keys, ...}:
let
    cfg = config.remote-access;
in
{
    options.remote-access.lunarix = lib.mkEnableOption "give lunarix root access";
    config = lib.mkIf cfg.lunarix {

        services.openssh.enable = true;
        networking.firewall.allowedTCPPorts = config.services.openssh.ports;
        networking.firewall.allowedUDPPorts = config.services.openssh.ports;

        users.users = {
            lunarix.openssh.authorizedKeys.keys = [ config.keys.flagship.lunarix.ssh ];
            root.openssh.authorizedKeys.keys = [ config.keys.flagship.lunarix.ssh ];
        };

        nix.settings.trusted-public-keys = [
            config.keys.flagship.store
        ];
    };
}

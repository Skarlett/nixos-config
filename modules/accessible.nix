{config, lib, pkgs, keys, ...}:
{
    users.users.lunarix.openssh.authorizedKeys.keys = [ keys.flagship.lunarix ];
}
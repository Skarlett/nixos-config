{keys, lib, config, pkgs, ...}:
{
    services.openssh.enable = true;
    services.gitolite.enable = true;
    services.gitolite.user = "git";
    services.gitolite.group = "git-user";
    services.gitolite.adminPubkey = keys.flagship.lunarix;
}

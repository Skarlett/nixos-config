{lib, config, ...}:
with lib;
{
    config = {};
    options.keys.flagship = {
        lunarix.ssh = mkOption {
            type = lib.types.str;
            default = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILcon6Pn5nLNXEuLH22ooNR97ve290d2tMNjpM8cTm2r";
            description = "SSH public key for lunarix:flagship";
        };
        root.ssh = mkOption {
            type = lib.types.str;
            default = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOrdriTG3e3SmTnhPeTJJH7WEwng5rS7epV/znc+5Zc4";
            description = "SSH public key for root:flagship";
        };

        store = mkOption {
            type = lib.types.str;
            default = "flagship:K8osZR0wBipQN319RV8ESLgZPFeG0pOGKg/f0C+TK7U=";
            description = "Store public key for flagship";
        };

        cachix.coggiebot = mkOption {
            type = lib.types.str;
            default = "coggiebot.cachix.org-1:nQZzOJPdTU0yvMlv3Hy7cTF77bfYS0bbf35dIialf9k=";
            description = "Cachix public key for coggiebot";
        };
    };
}

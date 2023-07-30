{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.unallocatedspace;
in
{
  options.services.unallocatedspace = {
    enable = mkEnableOption "enable unallocatedspace";

    frontend = mkOption {
      type = types.str;
      default = "${pkgs.unallocatedspace-frontend}";
    };

    FQDN = mkOption {
      type = types.str;
      default = pkgs.unallocatedspace-frontend.passthru.FQDN;
      example = "example.com";
    };
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ 80 443 ];
    users.users.lighttpd.extraGroups = ["acme"];

    environment.systemPackages = [];
    services.lighttpd = {
      enable = true;
      enableModules = [
        "mod_status"
        "mod_openssl"
      ];

      extraConfig =
        let
          acme-dir = "${config.security.acme.certs."${cfg.FQDN}".directory}";
          acme-conf = ''
            ssl.privkey = "${acme-dir}/privkey.pem"
            ssl.pemfile = "${acme-dir}/fullchain.pem"
          '';
        in
        ''
          $SERVER["socket"] == ":443" {
            ${
              if config.security.acme.acceptTerms
              then acme-conf
              else ""
            }
            ssl.engine = "enable"
            ssl.openssl.ssl-conf-cmd = ("Protocol" => "-ALL, TLSv1.2, TLSv1.3")
            server.name = "${cfg.FQDN}"
          }

          $HTTP["host"] == "${cfg.FQDN}" {
            ${
              if config.security.acme.acceptTerms
              then acme-conf
              else ""
            }
            server.document-root = "${cfg.frontend}"
          }
          ${if config.security.acme.acceptTerms
          then
            ''
            $HTTP["url"] =~ "/\.well-known/acme-challenge" {
              server.document-root = "${
                config.security.acme.certs.${cfg.FQDN}.directory
              }/${cfg.FQDN}/"
            }
            ''
          else ""}
        '';
    };
  };
}

{ self, config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.unallocatedspace;
  frontend = self.packages.${pkgs.system}.unallocatedspace-frontend;
  FQDN = frontend.passthru.FQDN;
in
{
  options.services.unallocatedspace = {
    enable = mkEnableOption "enable unallocatedspace";

    FQDN = mkOption {
      type = types.str;
      default = FQDN;
      example = "example.com";
    };

    acme = mkOption {
      type = types.option types.attrs;
      default = {
        enable = true;
        certs = {
          "${FQDN}" = {
            directory = "/var/lib/acme/${FQDN}";
            email = "root@${FQDN}";
          };
        };
      };
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
          # acme-dir = "${config.security.acme.certs."${FQDN}".directory}";
          acme-dir = "/var/lib/acme/unallocatedspace.dev";
          acme-conf = ''
            ssl.privkey = "${acme-dir}/privkey.pem"
            ssl.pemfile = "${acme-dir}/fullchain.pem"
          '';
        in
        ''
          $SERVER["socket"] == ":443" {
            ${acme-conf}
            ssl.engine = "enable"
            ssl.openssl.ssl-conf-cmd = ("Protocol" => "-ALL, TLSv1.2, TLSv1.3")
            server.name = "${FQDN}"
          }

          $HTTP["host"] == "${FQDN}" {
            ${acme-conf}
            server.document-root = "${frontend}"
          }

          $HTTP["url"] =~ "/\.well-known/acme-challenge" {
            server.document-root = "${acme-dir}/${FQDN}/"
          }
        '';
    };
  };
}

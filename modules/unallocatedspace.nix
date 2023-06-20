{ self, config, lib, pkgs, ... }:
let
  FQDN = "unallocatedspace.dev";
  frontend = self.packages.${pkgs.system}.unallocatedspace-frontend;
in
{
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  users.groups.www = {};
  environment.systemPackages = [];
  users.users.lighttpd.extraGroups = ["acme"];
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
          #ssl.openssl.ssl-conf-cmd = ("Protocol" => "-ALL, TLSv1.2, TLSv1.3")
          server.name = "${FQDN}"
        }

        $HTTP["host"] == "${FQDN}" {
          ${acme-conf}
          server.document-root = "${frontend}/dist"
        }

        $HTTP["url"] =~ "/\.well-known/acme-challenge" {
         server.document-root = "${acme-dir}/${FQDN}/"
        }
      '';
  };
}

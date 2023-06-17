{ config, lib, pkgs, ... }:
let
  FQDN = "unallocatedspace.dev";
  frontend = pkgs.callPackage ./frontend {
    inherit FQDN;
    REDIRECT="https://github.com/skarlett";
  };
in
{
  security.acme.acceptTerms = true;
  security.acme.defaults.email = "360d@pm.me";
  security.acme.defaults.group = "acme";
  security.acme.certs."${FQDN}" = {
    group = "acme";
    directory = "/var/lib/acme/unallocatedspace.dev/";
    reloadServices = ["lighttpd.service"];
  };

  users.users.lighttp.extraGroups = ["acme"];
  services.lighttpd = {
    enable = true;
    document-root = "${frontend}/dist";
    enableModules = [
      "mod_status"
      "mod_openssl"
    ];

    extraConfig =
      let
         acme-dir = "${config.security.acme."${FQDN}".directory}";
         acme-conf = ''
           ssl.privkey = "${acme-dir}/privkey.pem"
           ssl.pemfile = "${acme-dir}/fullchain.pem"
          '';
      in
      ''
        server.username  = "lighttpd"
        server.groupname = "lighttpd"

        $SERVER["socket"] == ":443" {
          ${acme-conf}
          ssl.engine = "enable"
          ssl.openssl.ssl-conf-cmd = ("Protocol" => "-ALL, TLSv1.2, TLSv1.3")
          server.name = "${FQDN}"
        }

        $HTTP["host"] == "${FQDN}"
          ${acme-conf}
          server.document-root = "${frontend}"
        }

        $HTTP["url"] =~ "/\.well-known/acme-challenge" {
          server.document-root = "${acme-dir}/${FQDN}/"
        }
      '';
  };
}

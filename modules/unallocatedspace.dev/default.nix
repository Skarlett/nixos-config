{ config, lib, pkgs, ... }:
let
  FQDN = "unallocatedspace.dev";
  frontend = pkgs.callPackage ./frontend {
    inherit FQDN;
    REDIRECT="https://github.com/skarlett";
  };
in
{
  networking.firewall.allowedTCPPorts = [ 80 443 4443 ];
  # security.acme.acceptTerms = true;
  # security.acme.defaults.email = "360d@pm.me";
  # security.acme.defaults.group = "acme";
  # security.acme.certs."${FQDN}" = {
  #   group = "acme";
  #   webroot = "/var/lib/acme/unallocatedspace.dev/"
  #   reloadServices = ["lighttpd.service"];
  #   listenHTTP = ":4443";
  # };

  users.groups.www = {};
  environment.systemPackages = [frontend];
  services.lighttpd = {
    enable = true;
    enableModules = [
      "mod_status"
      "mod_openssl"
    ];

    extraConfig =
      let
         acme-dir =""; #"${config.security.acme.certs."${FQDN}".directory}";
         acme-conf = ''
           #ssl.privkey = "${acme-dir}/key.pem"
           #ssl.pemfile = "${acme-dir}/fullchain.pem"
          '';
      in
      ''
        $SERVER["socket"] == ":443" {
          #''${acme-conf}
          #ssl.engine = "enable"
          #ssl.openssl.ssl-conf-cmd = ("Protocol" => "-ALL, TLSv1.2, TLSv1.3")
          server.name = "${FQDN}"
        }

        $HTTP["host"] == "${FQDN}" {
          #''${acme-conf}
          server.document-root = "${frontend}/dist"
        }

        $HTTP["url"] =~ "/\.well-known/acme-challenge" {
          server.document-root = "${acme-dir}/${FQDN}/"
        }
      '';
  };
}

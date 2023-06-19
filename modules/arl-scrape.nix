{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.arl-scrape;
in
{
  options.services.arl-scrape = {
    enable = mkEnableOption "coggiebot service";
    dir-dest = mkOption {
      type = types.string;
      default = "/var/log/stillfreearls";
    };

    user = mkOption {
      type = types.string;
      default = "arlscrape";
    };
  };

  config = mkIf cfg.enable {
    users.groups.${cfg.user} = {};
    users.users.${cfg.user} = {
      isSystemUser = true;
      createHome = true;
      home = "/var/log/arl";
      group = cfg.user;
    };

    systemd.services.arl-scrape = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      wants = [ "network-online.target" ];

      script = ''
        sleep 50
        mkdir -p ${cfg.dir-dest}
        ${pkgs.curl}/bin/curl -v "https://www.reddit.com/r/stillfreedeezerarl.json" 2> ${cfg.dir-dest}/errors.log  > ${cfg.dir-dest}/1.json;
      '';

      serviceConfig.Type = "simple";
      serviceConfig.User = cfg.user;
    };

    systemd.timers.arl-scrape = {
      after = [ "network.target" ];
      wants = [ "timers.target" ];
      timerConfig = {
        OnUnitActiveSec = "1d";
        Unit = "arl-scrape.service";
      };
    };
  };
}

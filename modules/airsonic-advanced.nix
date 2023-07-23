{ config, lib, pkgs, ...}:
with lib;
let
  cfg = config.services.airsonic-advanced;
in
{
  options.services.airsonic-advanced.enable = mkEnableOption "Enable airsonic-advanced";

  config = mkIf cfg.enable {
    services.airsonic = {
        enable = true;
        jre = pkgs.openjdk11;
        maxMemory = 4096;
        war = "${pkgs.self.airsonic-advanced-war.outPath}/webapps/airsonic.war";
        jveOptions = [
          "-server"
        ];
    };

    networking.firewall.allowedTCPPorts = [ config.services.airsonic.port ];
  };
}

{ config, lib, pkgs, ...}:
with lib;
let
  cfg = config.services.airsonic-advanced;
in
{
  options.services.airsonic-advanced = {
    enable = mkEnableOption "Enable airsonic-advanced";
    port = mkOption {
      type = types.int;
      default = 4040;
      description = "Port to listen on";
    };

    openFirewall = mkOption {
      type = types.bool;
      default = true;
      description = "Open port in firewall";
    };

    war = mkOption {
      default =
        "${pkgs.self.airsonic-advanced-war.outPath}/webapps/airsonic.war";
    };
  };

  config = mkIf cfg.enable {
    services.airsonic = {
        enable = true;
        jre = pkgs.openjdk11;
        maxMemory = 4096;
        war = cfg.war;
        port = cfg.port;
        jvmOptions = [
          "-server"
        ];
        listenAddress = "0.0.0.0";
    };
    networking.firewall.allowedTCPPorts = [ cfg.port ];
  };
}

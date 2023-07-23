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

    maxMemory = mkOption {
      type = types.int;
      default = 4096;
      description = "Maximum memory to use";
    };

    jvmOptions = mkOption {
      type = types.listOf types.str;
      default = ["-server"];
      description = "Additional JVM options";
    };

    jvmExtraOptions = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "Additions to default JVM options";
    };

    listenAddress = mkOption {
      type = types.str;
      default = "0.0.0.0";
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
        maxMemory = cfg.maxMemory;
        war = cfg.war;
        port = cfg.port;
        jvmOptions = cfg.jvmOptions ++ cfg.jvmExtraOptions;
        listenAddress = cfg.listenAddress;
    };
    networking.firewall.allowedTCPPorts = [ cfg.port ];
  };
}

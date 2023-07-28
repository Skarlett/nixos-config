{ config, lib, pkgs, ...}:
with lib;
let
  cfg = config.services.airsonic-advanced;
in
{
  options.services.airsonic-advanced = {
    enable = mkEnableOption "Enable airsonic-advanced";

    home = mkOption {
      type = types.str;
      default = "/var/lib/airsonic";
      description = "Home directory for airsonic";
    };

    user = mkOption {
      type = types.str;
      default = "airsonic";
      description = "User to run airsonic as";
    };

    group = mkOption {
      type = types.str;
      default = "airsonic";
      description = "Group to run airsonic as";
    };

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
      default = [
        "-server"
        "-Dairsonic.home=${config.services.airsonic.home}"
        "-Dserver.address=${cfg.listenAddress}"
        "-Dairsonic.contextPath=/"
        "-Djava.awt.headless=true"
      ];
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

    users.users.airsonic = {
      isSystemUser = true;
      createHome = true;
      home = cfg.home;
      name = cfg.user;
      group = cfg.group;
    };

    networking.firewall.allowedTCPPorts = [ 8080 ];
  };
}

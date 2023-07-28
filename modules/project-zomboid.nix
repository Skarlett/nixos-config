# README !!
# enabling this module requires you run
# pzserver manually at least once to set
# database credentials
# !!
{ config, lib, pkgs, ... }:
let cfg = config.gaming.project-zomboid-server;
in
{
  options.gaming.project-zomboid-server = {
    enable = lib.mkEnableOption "Enable Project Zomboid";

    package = lib.mkOption {
      default = pkgs.self.pzstart;
      description = "Package to use for Project Zomboid";
    };

    directPort = lib.mkOption {
      type = lib.types.int;
      default = 16262;
      description = "Port to run the server on";
    };

    negotiationPort = lib.mkOption {
      type = lib.types.int;
      default = 16261;
      description = "Port to run the server on";
    };

    # netfaces = lib.mkOption {
    #   type = lib.types.listOf lib.types.str;
    #   example = ["eth0"];
    #   default = [];
    # }
    # ;

    user = lib.mkOption {
      type = lib.types.str;
      default = "pzserver";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "pzserver";
    };

    servers = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "List of servers to run";
    };

    # declarative = lib.mkOption {
    #   type = lib.types.bool;
    #   default= false;
    # };

    # updateOnStartup = lib.mkOption {
    #   type = lib.types.bool;
    #   default = true;
    # };
  };

  config =
      (lib.mkIf cfg.enable
        {

          # systemd.tmpfiles.rules = [
          #   "t /run/pzsocks 0777 nobody nobody - - - - /run/pz.socket"
          # ];

          users.users.${cfg.user} = {
            isSystemUser = true;
            group = cfg.group;
            home = cfg.package.passthru.pzdir;
            createHome = true;
          };
          users.groups.${cfg.group} = {};

          systemd.sockets."project-zomboid-server" = {
            bindsTo = [ "project-zomboid-server.service" ];
            socketConfig = {
              ListenFIFO = "/run/pz.socket";
              SocketMode = "0660";
              SocketUser = cfg.user;
              SocketGroup = cfg.group;
              RemoveOnStop = true;
              FlushPending = true;
            };
          };

          systemd.services."project-zomboid-server" = {
            description = "Project Zomboid Server";
            wantedBy = [ "multi-user.target" ];
            requires = [ "project-zomboid-server.socket" ];
            after = [ "network.target" "project-zomboid-server.socket" ];
            serviceConfig = {
              Type = "simple";
              User = cfg.user;
              Group = cfg.group;

              WorkingDirectory = cfg.package.passthru.pzdir;
              ExecStart = "${cfg.package}/bin/pzstart";
              ExecStop = "echo 'quit' > /run/pz.socket && sleep 30";

              StandardInput = "socket";
              StandardOutput = "journal";
              StandardError = "journal";

              # Hardening
              # CapabilityBoundingSet = [ "" ];
              # DeviceAllow = [ "" ];
              # LockPersonality = true;
              # PrivateDevices = true;
              # PrivateTmp = true;
              # PrivateUsers = true;
              # ProtectClock = true;
              # ProtectControlGroups = true;
              # ProtectHome = true;
              # ProtectHostname = true;
              # ProtectKernelLogs = true;
              # ProtectKernelModules = true;
              # ProtectKernelTunables = true;
              # ProtectProc = "invisible";
              # RestrictAddressFamilies = [ "AF_INET" "AF_INET6" ];
              # RestrictNamespaces = true;
              # RestrictRealtime = true;
              # RestrictSUIDSGID = true;
              # SystemCallArchitectures = "native";
              # UMask = "0077";
            };
          };
        });
}

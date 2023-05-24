{ config, pkgs, lib, ... }:
let
   my_df = pkgs.dwarf-fortress.override {
     enableIntro = false;
     enableSound = false;
   };

   # dark_ghidra = pkgs.ghidra.overrideAttrs (old: {
   #   patches = (old.patches or []) ++ [];
   # });
in
{
  #services.coggiebot.enable = true;
  #services.coggiebot.api-key = "NDYxMzU5NjUwNDk2MDUzMjU4.GZYTlU.SFyeDpZrjrcRd-FFQGt3Leh_wPtygpdJR4isyg";
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  services.clamav.daemon.enable = true;
  services.clamav.updater.enable = true;
  overlays.unstable.enable = true;

  nixpkgs.config = {
     allowUnfree = true;
      #pulseaudio = true;
   };

  hardware.opengl = {
    driSupport = true;
    driSupport32Bit = true;
  };

  security.rtkit.enable = true;
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  #services.pipewire = {
  #     enable = true;
  #     alsa.enable = true;
  #     alsa.support32Bit = true;
       #pulse.enable = true;
       #systemWide = true;
  #   };

  imports = [
      ./hardware-configuration.nix
    ];
  
  boot.loader = {
      systemd-boot.enable = true;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
    };

  # Setup keyfile
  boot.initrd.secrets = {
      "/crypto_keyfile.bin" = null;
    };

  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true;

  time.timeZone = "America/Chicago";
  i18n.defaultLocale = "en_US.utf8";

  services.xserver = {
    enable = true;
    layout = "us";
    xkbVariant = "";
    displayManager.lightdm.enable = true;
    desktopManager.cinnamon.enable = true;
    videoDrivers = [ "nvidia" ];
  };

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  users.users.root = {
    shell = pkgs.fish;
  };

  users.users.lunarix = {
    shell = pkgs.fish;
    isNormalUser = true;
    description = "pewter";
    extraGroups = [ "networkmanager" "wheel" "audio" ];
  };
  nixpkgs.config.permittedInsecurePackages = [
    "python-2.7.18.6"
  ];


  documentation.dev.enable = true;
  #documentation.dev.generateCaches = true;
  
  programs.fish = { inherit (import ./fish.nix);};
  environment.systemPackages = with pkgs; [
     nfs-utils
     man-pages
     man-pages-posix
     lsd
     bat
     unzip
     vim
     wget
     tor
     parted
     fish
     lsof
     binutils
     file
     nixfmt
  ];

  services.printing.enable = true;
  services.openssh.enable = true;
  networking.firewall = {
    allowedUDPPorts = [ 51820 ]; # Clients and peers can use the same port, see listenport
  };

  # services.openvpn.servers = {
  #   client = {
  #     config = ''
  #       dev tun
	# persist-tun
	# persist-key
	# data-ciphers AES-128-GCM
	# data-ciphers-fallback AES-128-GCM
	# auth SHA256
	# tls-client
	# client
	# resolv-retry infinite
	# remote 10.0.0.52 1194 udp4
	# nobind
	# verify-x509-name "openvpn-server" name
	# pkcs12 /etc/nixos/vpn/certs.p12
	# tls-auth /etc/nixos/vpn/tls-key 1
	# remote-cert-tls server
	# explicit-exit-notify
  #     '';

  #     up = "echo nameserver $nameserver | ${pkgs.openresolv}/sbin/resolvconf -m 0 -a $dev";
  #     down = "${pkgs.openresolv}/sbin/resolvconf -d $dev";
  #   };
  # };

  services.syncthing = {
    enable = true;
    user = "lunarix";
    dataDir = "/home/lunarix/Sync";
    configDir = "/home/lunarix/.config/syncthing";

    overrideDevices = false;
    overrideFolders = false;
    devices = {
      # "coggie" = { id = "DEVICE-ID-GOES-HERE"; };
    };

    folders = {
      "Sync" = {
        path = "/home/lunarix/Sync";
        devices = [  ];
      };
    };
  };

  services.tor.enable = true;
  services.tor.client.enable = true;
  services.tor.torsocks.enable = true;
  services.tor.torsocks.server = "127.0.0.1:9050";
  services.privoxy.enable = true;  
  services.privoxy.enableTor = true;
  # Forward .onion requests to Tor
  services.privoxy.settings.forward-socks5t = "/ 127.0.0.1:9050 .";

  systemd.user.services."backup" =
    let ignore=''
        lunarix/.cache
        target/
        .cpan
        .cache
        .cargo
        .config/discord
        .config/Code/CachedData
        .config/Signal
        .config/godot
        .config/fish
        .config/discordcanary
        .config/chromium
        .config/Code/Cache
        .config/Code/logs
        .config/Code/User/workspaceStorage
        .config/Code/Service Worker/
        .config/Code/Local Storage/
        .config/Code/GPUCache/
        .cataclysm-dda
        .config/0ada
        .config/transmission/resume
        .config/transmission/torrents
        .config/nvtop
        .config/libreoffice
        .config/gtk-*
        .config/font-manager
        .config/cointop
        .config/btop
        .SpaceVim
        .cinnamon
        .anydesk
        .emacs.d
        .local/share
        .mozilla
        .config/Code/User/History/
        .npm
        .rustup
        Zomboid/Logs
        .texlive*
        .frostwire5
        .ipfs
        perl5
        target/
        node_modules
    '';
    in {
    enable = false;
    description = "backup home directory";
    after = [
         "multi-user.target"
         "networking.target"
    ];

    environment = {
        BACKUPKEY = "/home/lunarix/.ssh/backup.key";
        EXCLUDE = "/home/lunarix/.config/backup.ignore";
    };

    startAt = [ "*-*-* 13:00:00" ];
    script = ''
        eval "echo \"$(cat $EXCLUDE)\"" > /tmp/backup_list

        ${pkgs.rsync}/bin/rsync --max-size=100m \
          -e "${pkgs.openssh}/bin/ssh -i \$BACKUPKEY" \
          --exclude-from=/tmp/backup_list \
          -ranzd \
          /home/ upload@10.0.0.3:/srv/nfs

    '';

    serviceConfig.Type = "oneshot";
  };
  
  # This honestly needs its own derivation
  # where our backup.ignore file is a list instead
  # and our ssh backup-key is also a string
  # systemd.user.services."on-boot" = {
  #   enable = false;
  #   description = "my daily startup";
  #   after = [ "multi-user.target" ];
  #   environment = {
  #       BACKUPKEY = "/home/lunarix/.ssh/backup.key";
  #       EXCLUDE = "/home/lunarix/.config/backup.ignore";
  #   };
  #   script = '' rm -rf $HOME/Downloads '';
  #   serviceConfig.Type = "oneshot";
  # };

  system.stateVersion = "22.11"; # DO NOT CHANGE (without consequences)
}



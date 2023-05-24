{ self, config, pkgs, lib, ... }:
# let
   # dark_ghidra = pkgs.ghidra.overrideAttrs (old: {
   #   patches = (old.patches or []) ++ [];
   # });
# in
{

  imports = [
    ./hardware-configuration.nix
    self.inputs.nix-ld.nixosModules.nix-ld
  ];

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  hardware.opengl = {
    driSupport = true;
    driSupport32Bit = true;
  };

  services.clamav.daemon.enable = true;
  services.clamav.updater.enable = true;
  security.rtkit.enable = true;
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  
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
  system.stateVersion = "22.11";
}



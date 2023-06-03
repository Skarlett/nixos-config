{ self, config, pkgs, lib, ... }:
# let
   # dark_ghidra = pkgs.ghidra.overrideAttrs (old: {
   #   patches = (old.patches or []) ++ [];
   # });
# in
{

  imports = [
    self.inputs.nix-ld.nixosModules.nix-ld
  ];

  nix.settings.trusted-users = [ "lunarix" ];
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
    displayManager.lightdm.enable = true;
    desktopManager.cinnamon.enable = true;
    videoDrivers = [ "nvidia" ];
  };
  nixpkgs.config.permittedInsecurePackages = [
    "openssl-1.1.1u" # steam
  ];
 
  documentation.dev.enable = true;
  environment.systemPackages = with pkgs; [
    nfs-utils
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
    self.inputs.deploy.packages."x86_64-linux".default
  ];

  services.printing.enable = true;
  services.openssh.enable = true;
  networking.firewall = {
    allowedUDPPorts = [ 51820 ]; # Clients and peers can use the same port, see listenport
  };

  # services.syncthing = {
  #   enable = true;
  #   user = "lunarix";
  #   dataDir = "/home/lunarix/Sync";
  #   configDir = "/home/lunarix/.config/syncthing";

  #   overrideDevices = false;
  #   overrideFolders = false;
  #   devices = {
  #     # "coggie" = { id = "DEVICE-ID-GOES-HERE"; };
  #   };

  #   folders = {
  #     "Sync" = {
  #       path = "/home/lunarix/Sync";
  #       devices = [  ];
  #     };
  #   };
  # };

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



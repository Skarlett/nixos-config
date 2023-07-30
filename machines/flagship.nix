{ inputs, config, pkgs, lib, ... }:
# let
   # dark_ghidra = pkgs.ghidra.overrideAttrs (old: {
   #   patches = (old.patches or []) ++ [];
   # });
# in
{
  common.enable = true;
  networking.hostName = "flagship";

  # home-manager.users.lunarix = import ../home-manager/flagship.nix;
  # home-manager.useGlobalPkgs = true;
  # home-manager.useUserPackages = true;

  # Enable cap_sys_resource for noisetorch.
  security.wrappers.noisetorch = {
    owner = "root";
    group = "root";
    capabilities = "cap_sys_resource+ep";
    source = "${pkgs.noisetorch}/bin/noisetorch";
  };

  # chaotic.linux_hdr.specialisation.enable = true;
  chaotic.steam.extraCompatPackages = [ pkgs.proton-ge-custom ];
  services.arl-scrape.enable = true;

  nix.settings.trusted-users = [ "lunarix" ];
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  hardware.opengl = {
    driSupport = true;
    driSupport32Bit = true;
  };

  networking.firewall.allowedUDPPorts = [ 51820 51821 ];
  networking.wg-quick.interfaces.luni = {
    address = ["fd01:1:a1:1::1" "10.51.0.1"];
    privateKeyFile = "/etc/nixos/keys/wireguard/6/lunarix.pem";
    listenPort = 51820;
    peers = config.luninet.gateways;
  };

  #security.pam.enableFscrypt
  # security.pam.enableEcryptfs = mkEnableOption
  # (lib.mdDoc "eCryptfs PAM module (mounting ecryptfs home directory on login)");
  services.clamav.daemon.enable = true;
  services.clamav.updater.enable = true;
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
    qdirstat
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
    noisetorch
    self.inputs.deploy.packages."x86_64-linux".default
    nfs-utils
  ];

  services.printing.enable = true;
  services.openssh.enable = true;

  services.tor.enable = true;
  services.tor.client.enable = true;
  services.tor.torsocks.enable = true;
  services.tor.torsocks.server = "127.0.0.1:9050";
  services.privoxy.enable = true;  
  services.privoxy.enableTor = true;

  # Forward .onion requests to Tor
  services.privoxy.settings.forward-socks5t = "/ 127.0.0.1:9050 .";
  # system.stateVersion = "22.05";
}



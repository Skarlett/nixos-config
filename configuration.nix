{ config, pkgs, lib, ... }:
let
   nix-alien =
     import (
       fetchTarball https://github.com/thiagokokada/nix-alien/tarball/master
     ) {};

   my_df = pkgs.dwarf-fortress.override {
     enableIntro = false; enableSound = false;
   };

   unstableTarball =
     fetchTarball
       https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz;
in
{
  # Touch pad 
  # services.xserver.libinput.enable = false;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config = {
    allowUnfree = true;
    packageOverrides = pkgs: {
      unstable = import unstableTarball {
        config = config.nixpkgs.config;
      };
    };
  };

  hardware.opengl.driSupport = true;
  #hardware.opengl.driSupport32Bit = true;
  # if gpu locks screen on bootup
  # boot.blacklistedKernelModules = [ "i915" ];

  imports =
  [
      # <home-manager/nixos>
      ./hardware-configuration.nix
      ./vscode.nix
  ];
  
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # boot.extraModulePackages = [ config.boot.kernelPackages.wireguard ];
  
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

  security.sudo.extraConfig = ''
      Defaults insults
  '';

  security.rtkit.enable = true;
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  users.users.root = {
    shell = pkgs.fish;
  };

  users.users.lunarix = {
    shell = pkgs.fish;
    isNormalUser = true;
    description = "pewter";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs;
    [
      unstable.discord

      flameshot
      tree
      pandoc
      gnumake
      texlive.combined.scheme-context      
      file
      dolphin-emu
      elementary-planner
      zeroad
      
      binutils
      ripgrep
      emacs
      firefox
      tor-browser-bundle-bin
      
      vscode
      kitty
      kitty-themes
      diff-so-fancy
      xclip
      git
      cowsay
      pavucontrol
      steam
      spotify
      aide
      neofetch
      keepassxc     

      nerdfonts
      gparted
      tmux
      powershell
      btop
      htop
      bmon
      ghidra-bin
      
      dig
      nmap
      python3
      jq
      my_df
      # niv
      steamcmd
      thunderbird
      signal-desktop
      node2nix
      nodejs
      xdg-utils      
      nodePackages.rimraf
      nodePackages.typescript
      vulnix
      nix-alien.nix-alien
      nix-alien.nix-index-update
      nix-index
      font-manager 
      wireguard-tools
      starship      
      libreoffice-fresh     
      rust-analyzer
      yara # malware 
      virtualenv
      openvpn
      obsidian

      anydesk
      clang-tools
      lldb
      helix
      #cargo
      clang
      #rust-analyzer
      rustup
    
    ];
  };

  programs.fish =
  {
    enable = true;
    vendor.functions.enable = true;
    vendor.config.enable = true;
    vendor.completions.enable = true;
    shellInit = ''
        # Spawns process outside of shell access
        function spawn
          $argv > /dev/null 2>&1 &
          disown
        end
    '';

    shellAliases = 
    {
        #ssh="set TERM=xterm-256color; ssh";
        ls="lsd --color always";
        l="ls -la";
        la="ls -a";
        lt="ls -tree";
        gr="git reset --soft HEAD~1";
        glog="git log --graph \
                 --pretty=format:'%Cred%h%Creset %an: %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset' \
                 --abbrev-commit \
                 --date=relative";
        gd="git diff --color | sed 's/^\([^-+ ]*\)[-+ ]/\\1/' | less -r";
        clr="clear";
        cls="clear";
        cp="cp -r";
        tmux = "tmux -u";
        clipboard="xclip -selection c";
        more = "less";
        cat = "bat";
        ".." = "cd ..";
        "..." = "cd ../..";
        vol = "pactl -- set-sink-volume 0";
        dmesg="dmesg --color=always";
    };
  };


  programs.starship.enable = true;

  programs.starship.settings = {
    add_newline = false;
    format = "$shlvl$shell$username$hostname$nix_shell$git_branch$git_commit$git_state$git_status$directory$jobs$cmd_duration$character";
    shlvl = {
      disabled = false;
      symbol = "ﰬ";
      style = "bright-red bold";
    };
    shell = {
      disabled = false;
      format = "$indicator";
      fish_indicator = "";
      bash_indicator = "[BASH](bright-white) ";
      zsh_indicator = "[ZSH](bright-white) ";
    };
    username = {
      style_user = "bright-white bold";
      style_root = "bright-red bold";
    };
    hostname = {
      style = "bright-green bold";
      ssh_only = true;
    };
    nix_shell = {
      symbol = "";
      format = "[$symbol$name]($style) ";
      style = "bright-purple bold";
    };
    git_branch = {
      only_attached = true;
      format = "[$symbol$branch]($style) ";
      symbol = "שׂ";
      style = "bright-yellow bold";
    };
    git_commit = {
      only_detached = true;
      format = "[ﰖ$hash]($style) ";
      style = "bright-yellow bold";
    };
    git_state = {
      style = "bright-purple bold";
    };
    git_status = {
      style = "bright-green bold";
    };
    directory = {
      read_only = " ";
      truncation_length = 0;
    };
    cmd_duration = {
      format = "[$duration]($style) ";
      style = "bright-blue";
    };
    jobs = {
      style = "bright-green bold";
    };
    character = {
      success_symbol = "[\\$](bright-green bold)";
      error_symbol = "[\\$](bright-red bold)";
    };
  };

  environment.systemPackages = with pkgs; [
     lsd
     bat
     unzip
     vim
     wget
     tor
     parted
     fish
  ];

  services.printing.enable = true;
  services.openssh.enable = true;

  networking.firewall = {
    allowedUDPPorts = [ 51820 ]; # Clients and peers can use the same port, see listenport
  };

  services.openvpn.servers = {
    client = {
      config = ''
        dev tun
	persist-tun
	persist-key
	data-ciphers AES-128-GCM
	data-ciphers-fallback AES-128-GCM
	auth SHA256
	tls-client
	client
	resolv-retry infinite
	remote 10.0.0.52 1194 udp4
	nobind
	verify-x509-name "openvpn-server" name
	pkcs12 /etc/nixos/vpn/certs.p12
	tls-auth /etc/nixos/vpn/tls-key 1
	remote-cert-tls server
	explicit-exit-notify
      '';

      up = "echo nameserver $nameserver | ${pkgs.openresolv}/sbin/resolvconf -m 0 -a $dev";
      down = "${pkgs.openresolv}/sbin/resolvconf -d $dev";
    };
  };

  vscode.user = "lunarix";
  vscode.homeDir = "/home/lunarix"; 
  vscode.extensions = with pkgs.vscode-extensions; [
    # bbenoist.Nix
    # WakaTime.vscode-wakatime
    vadimcn.vscode-lldb  
  ]; 
  # this honestly needs its own derivation
  # where our backup.ignore file is a list instead
  # and our ssh backup-key is also a string
  systemd.user.services."backup-home" = {
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
          -rav \
          /home upload@10.0.0.3:/srv/nfs
    '';

    serviceConfig.Type = "oneshot";
  };
  
  # This honestly needs its own derivation
  # where our backup.ignore file is a list instead
  # and our ssh backup-key is also a string
  systemd.user.services."on-boot" = {
    enable = false;
    description = "my daily startup";
    after = [
         "multi-user.target"
    ];

    environment = {
        BACKUPKEY = "/home/lunarix/.ssh/backup.key";
        EXCLUDE = "/home/lunarix/.config/backup.ignore";
    };

    script = ''
        rm -rf $HOME/Downloads
    '';

    serviceConfig.Type = "oneshot";
  };

  system.stateVersion = "22.05"; # DO NOT CHANGE (without consequences)
}

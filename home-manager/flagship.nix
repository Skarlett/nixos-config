{ self, config, lib, pkgs, nur, nix-doom-emacs, ... }: {
  nixpkgs.overlays = [ nur.overlay ];
  imports = with self.inputs; [ 
    nix-doom-emacs.hmModule
    nur.hmModules.nur
    ./modules/vscode
    ./modules/fish.nix
    ./modules/firefox.nix  
  ];

  programs.doom-emacs = {
    enable = true;
    doomPrivateDir = ./doom;
    extraPackages = [ pkgs.ripgrep ];
  };

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "lunarix";
  home.homeDirectory = "/home/lunarix";

  home.stateVersion = "22.11";
  programs.home-manager.enable = true;
  # programs.fish.enable = true;

  home.packages = with pkgs; [
    nixos-generators
    firefox
    unstable.discord
    pulseaudio
    gdb
    nix-alien
    flameshot
    tree
    pandoc

    sonixd
    texlive.combined.scheme-context
    zeroad
    ripgrep
    ispell
    kitty
    kitty-themes
    diff-so-fancy
    xclip
    git
    pavucontrol
    steam
    spotify
    keepassxc
    nerdfonts
    tmux
    powershell
    htop
    dig
    nmap
    python3
    jq

    steamcmd
    thunderbird
    xdg-utils
    nix-index
    font-manager
    wireguard-tools
    libreoffice-fresh
    openvpn
    obsidian
    anydesk

    lldb
    glfw
    clang
    # python2
    rustfmt
    unstable.cargo
    unstable.rustc
    rust-analyzer

    (pkgs.dwarf-fortress.override {
      enableIntro = false;
      enableSound = false;
    })

    tor-browser-bundle-bin
    transmission-gtk

    man-pages
    man-pages-posix
  ];

  programs.git = {
    enable = true;
    userName = "Skarlett";
    userEmail = "360d@pm.me";
  };
}

{ config, lib, pkgs, nix-doom-emacs, nur, ... }:
{
  nixpkgs.overlays = [ nur.overlay ];
  imports = [ 
    nix-doom-emacs.hmModule
    nur.hmModules.nur
  ];

  programs.doom-emacs = {
     enable = true;
     doomPrivateDir = ./doom; 
  };
  
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "lunarix";
  home.homeDirectory = "/home/lunarix";

  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = with pkgs; [ 
      cowsay 
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
      #clang-tools
      lldb
      glfw
      clang
      python2
      rustfmt
      unstable.cargo
      unstable.rustc
      rust-analyzer

      tor-browser-bundle-bin
      # transmission
      transmission-gtk
      prismlauncher      
      man-pages
      man-pages-posix
  ];
  
  programs.firefox = {
     enable = true;
     extensions = with pkgs.nur.repos.rycee.firefox-addons; [
       privacy-badger
       darkreader
       keepassxc-browser
       ublock-origin
    ];
  };

  programs.vscode = {
    package = pkgs.unstable.vscode;
    enable = true;
    extensions = with pkgs.unstable.vscode-extensions; [
      bbenoist.nix
      vadimcn.vscode-lldb
      matklad.rust-analyzer
      ms-vscode.makefile-tools
      ms-vscode.cmake-tools
      ms-vscode.cpptools
      ms-vscode.theme-tomorrowkit
      ms-vscode.hexeditor
      ms-vscode-remote.remote-ssh
      ms-vsliveshare.vsliveshare
      kahole.magit
      ms-python.vscode-pylance
      arrterian.nix-env-selector
      WakaTime.vscode-wakatime
      vscodevim.vim
      usernamehw.errorlens
      stephlin.vscode-tmux-keybinding
      github.copilot
    ];
    # enableExtensionUpdateCheck = false;

    userSettings = {
      "workbench.colorTheme" = "Default Dark+";
      "rust-analyzer.procMacro.enable" = false;
      "rust-analyzer.procMacro.attributes.enable" = false;
      "editor.inlineSuggest.enabled"= true;
      "workbench.sideBar.location"= "right";
      "workbench.colorCustomizations" = {
        "statusBar.background"= "#822be0";
      };
    };
  };

  programs.git = {
    enable = true;
    userName = "Skarlett";
    userEmail = "360d@pm.me";
  };
}

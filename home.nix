{ self, config, lib, pkgs, nur, nix-doom-emacs, ... }:
{
  nixpkgs.overlays = [ nur.overlay ];
  imports = [ 
    nix-doom-emacs.hmModule
    nur.hmModules.nur
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

  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = with pkgs; [ 
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
      python2
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
    keybindings = builtins.fromJSON (builtins.readFile ./keybindings.json);
    extensions = with pkgs.unstable.vscode-extensions; [
      arrterian.nix-env-selector
      bbenoist.nix
      eamodio.gitlens
      github.copilot
      github.vscode-pull-request-github
      kahole.magit
      matklad.rust-analyzer
      ms-python.vscode-pylance
      ms-vscode-remote.remote-ssh
      ms-vscode.cmake-tools
      ms-vscode.cpptools
      ms-vscode.hexeditor
      ms-vscode.makefile-tools
      ms-vscode.theme-tomorrowkit
      ms-vsliveshare.vsliveshare
      stephlin.vscode-tmux-keybinding
      usernamehw.errorlens
      vadimcn.vscode-lldb
      vscodevim.vim
      vspacecode.vspacecode
      vspacecode.whichkey
      WakaTime.vscode-wakatime
      bodil.file-browser
    ]
    ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "vscode-indent-line";
        publisher = "sandipchitale";
        version = "1.0.1";
        sha256 = "Zygw5XOEEF4Fj7IZyuC+ZKCG8Yb3B0WsD+OwmDBQiMk=";
      }
    ];

    userSettings = {
      "whichkey.delay" = 900;
      "workbench.quickOpen.delay"= 900;
      "vspacecode.bindingOverrides" = [
        {
          "name" = "Git log";
          "type" = "command";
          "keys" = "g.g";
          "command" = "magit.status";
        }
        {
          "name" = "Terminal";
          "type" = "command";
          "keys" = "x";
          "command" = "workbench.action.terminal.focus";
        }
        {
          "name" = "Reload window";
          "command" = "workbench.action.reloadWindow";
          "keys" = "w.r";
          "type" = "command";
        }
        {
          "name" = "close window";
          "type" = "command";
          "keys" = "w.q";
          "command" = "workbench.action.closePanel";
        }
        {
          "name" = "Find files";
          "type" = "command";
          "keys" = "f.f";
          "command" = "file-browser.open";
        }
        {
          "name" = "Open Recent";
          "type" = "command";
          "keys" = " ";
          "command" = "workbench.action.quickOpen";
        }
      ];
      "editor.autoIndent" = "full";
      "vim.easymotion" = true;
      "vim.useSystemClipboard" = true;
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

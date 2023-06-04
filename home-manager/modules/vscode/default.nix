{config, lib, ...}:
{
    programs.vscode = {
        package = pkgs.unstable.vscode;
        enable = true;
        keybindings = builtins.fromJSON (builtins.readFile ./keybindings.json);
        extensions = with pkgs.unstable.vscode-extensions;
        [
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
        ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [{
            name = "vscode-indent-line";
            publisher = "sandipchitale";
            version = "1.0.1";
            sha256 = "Zygw5XOEEF4Fj7IZyuC+ZKCG8Yb3B0WsD+OwmDBQiMk=";
        }];

        userSettings = {
        "whichkey.delay" = 900;
        "workbench.quickOpen.delay" = 900;
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
        "editor.inlineSuggest.enabled" = true;
        "workbench.sideBar.location" = "right";
        "workbench.colorCustomizations" = { "statusBar.background" = "#822be0"; };
    };
};
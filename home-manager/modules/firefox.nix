{config, lib, pkgs, ...}:
{
 programs.firefox = {
    enable = true;
    profiles.lunarix = {
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        privacy-badger
        darkreader
        keepassxc-browser
        ublock-origin
      ];

      settings = {
        "browser.search.region" = "US";
        "browser.search.isUS" = true;
        "distribution.searchplugins.defaultLocale" = "en-US";
        "general.useragent.locale" = "en-US";
        "browser.newtabpage.pinned" = [{
          title = "Search NixOS";
          url = "https://search.nixos.org";
        }];
        # set to dark modew
        "browser.theme.content-theme" = 2;
        "browser.theme.toolbar-theme" = 2;
      };
    };
  };
}
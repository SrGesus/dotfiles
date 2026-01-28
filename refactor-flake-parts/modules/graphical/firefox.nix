{ ... }:
{
  flake.nixosModules.firefox =
    let
      default-false = {
        Value = false;
        Status = "default";
      };
      default-true = {
        Value = true;
        Status = "default";
      };
    in
    {
      programs.firefox = {
        enable = true;
        policies = {
          PasswordManagerEnabled = false;
          UserMessaging = {
            ExtensionRecommendations = false;
            FeatureRecommendations = true;
            UrlbarInterventions = false;
            SkipOnboarding = true;
            MoreFromMozilla = false;
            FirefoxLabs = true;
          };
          FirefoxHome = {
            Search = true;
            TopSites = true;
            SponsoredTopSites = false;
            Highlights = true;
            Pocket = false;
            SponsoredPocket = false;
            Snippets = false;
          };
          OfferToSaveLogins = false;
          SearchSuggestEnabled = false;
          SearchEngines.Default = "DuckDuckGo";
          SkipTermsOfUse = true;
          PromptForDownloadLocation = true;
          Homepage = {
            URL = "http://homeserver/";
            # StartPage = "none";
          };
          Containers = {
            "Default" = [
              {
                name = "Personal";
                icon = "circle";
                color = "orange";
              }
              {
                name = "Técnico";
                icon = "circle";
                color = "green";
              }
              {
                name = "Gaming";
                icon = "circle";
                color = "purple";
              }
            ];
          };
          Preferences = {
            # Warnings
            "browser.warnOnQuitShortcut" = default-false;
            "browser.warnOnQuit" = default-false;
            "browser.aboutConfig.showWarning" = default-false;
            # Sidebar
            "sidebar.verticalTabs" = default-true;
            "sidebar.revamp" = default-true;
            "sidebar.notification.badge.aichat" = default-false;
            "sidebar.new-sidebar.has-used" = default-true;
            "sidebar.verticalTabs.dragToPinPromo.dismissed" = default-true;
            "sidebar.main.tools" = {
              Value = "history,bookmarks,{531906d3-e22f-4a6c-a102-8057b88a1a63}";
              Status = "default";
            };
          };
          ExtensionSettings =
            builtins.mapAttrs
              (name: value: {
                installation_mode = "normal_installed";
                install_url = "https://addons.mozilla.org/firefox/downloads/latest/${value}/latest.xpi";
              })
              {
                "@testpilot-containers" = "multi-account-containers";
                "uBlock0@raymondhill.net" = "ublock-origin";
                "keepassxc-browser@keepassxc.org" = "keepassxc-browser";
                "plasma-browser-integration@kde.org" = "plasma-integration";
                "sponsorBlocker@ajay.app" = "sponsorblock";
                "{531906d3-e22f-4a6c-a102-8057b88a1a63}" = "single-file";
              };
        };
      };
    };
}

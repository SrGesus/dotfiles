{ ... }:
{
  programs.firefox = {
    enable = true;
    policies = {
      PasswordManagerEnabled = false;
      UserMessaging = {
        WhatsNew = false;
        ExtensionRecommendations = false;
        UrlbarInterventions = false;
        SkipOnboarding = false;
        MoreFromMozilla = false;
      };
      FirefoxHome = {
        Search = false;
        Highlights = false;
        Pocket = false;
        SponsoredPocket = false;
        Snippets = false;
        SponsoredTopSites = false;
      };
      OfferToSaveLogins = false;
      SearchSuggestEnabled = false;
      Homepage = {
        URL = "http://homeserver/";
        # StartPage = "none";
      };
    };
  };
}

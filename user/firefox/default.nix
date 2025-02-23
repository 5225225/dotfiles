{firefox-addons, ...}: {
  programs.firefox = {
    enable = true;
    profiles."1a0nke3z.default" = {
      userChrome = builtins.readFile ./userChrome.css;
      extensions.packages = [
        firefox-addons.ublock-origin
        firefox-addons.batchcamp
        firefox-addons.darkreader
        firefox-addons.decentraleyes
        # try replacing this with yarr
        # firefox-addons.feedbroreader
        firefox-addons.indie-wiki-buddy
        firefox-addons.keepassxc-browser
        firefox-addons.sidebery
        firefox-addons.sponsorblock
        firefox-addons.streetpass-for-mastodon
        firefox-addons.stylus
        firefox-addons.violentmonkey
        # firefox-addons.volume-control-for-bandcamp
        # firefox-addons.wave-evaluation-tool
        firefox-addons.wayback-machine
      ];

      settings = {
        "extensions.autoDisableScopes" = 0;
      };
    };
    policies = {
      AutofillAddressEnabled = false;
      AutofillCreditCardEnabled = false;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableSetDesktopBackground = true;
      DisableTelemetry = true;
      DNSOverHTTPS = {
        # Use system DNS instead, it *is* encrypted.
        Enabled = false;
        Locked = true;
      };

      DontCheckDefaultBrowser = true;
      EnableTrackingProtection = {
        Value = true;
        Cryptomining = true;
        Fingerprinting = true;
        EmailTracking = true;
        Locked = true;
      };

      PostQuantumKeyAgreementEnabled = true;

      UserMessaging = {
        ExtensionRecommendations = false;
        FeatureRecommendations = false;
        UrlbarInterventions = false;
        SkipOnboarding = true;
        MoreFromMozilla = false;
        Locked = true;
      };
    };
  };
}

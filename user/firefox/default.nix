{
  programs.firefox = {
    enable = true;
    profiles."1a0nke3z.default" = {
      userChrome = builtins.readFile ./userChrome.css;
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

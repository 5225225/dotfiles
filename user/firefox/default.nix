{ inputs, ... }:
let
  fa = inputs.firefox-addons;
in
{
  programs.firefox = {
    enable = true;
    profiles."1a0nke3z.default" = {
      userChrome = builtins.readFile ./userChrome.css;
      extensions.packages = [
        fa.ublock-origin
        fa.batchcamp
        fa.darkreader
        fa.decentraleyes
        fa.indie-wiki-buddy
        fa.keepassxc-browser
        fa.sidebery
        fa.sponsorblock
        fa.streetpass-for-mastodon
        fa.stylus
        fa.violentmonkey
        # fa.volume-control-for-bandcamp
        # fa.wave-evaluation-tool
        fa.wayback-machine
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

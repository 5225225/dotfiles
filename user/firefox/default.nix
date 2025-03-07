{ lib, inputs, ... }:
let
  fa = inputs.firefox-addons;
in
{
  programs.firefox = {
    enable = true;
    profiles."1a0nke3z.default" = {
      # TODO: move this to concatMapStrings
      userChrome = lib.strings.concatStrings [
        (builtins.readFile ./userChrome.css)
        (builtins.readFile ./transparentUserChrome.css)
      ];
      userContent = lib.strings.concatStrings [ (builtins.readFile ./transparentUserContent.css) ];
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
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "browser.tabs.allow_transparent_browser" = true;
        "security.OCSP.enabled" = 0;
        "font.name.sans-serif.x-western" = "Noto Sans";
        "browser.urlbar.suggest.searches" = false;
        "browser.search.suggest.enabled" = false;
      };
    };

    policies = {
      AutofillAddressEnabled = false;
      AutofillCreditCardEnabled = false;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableSetDesktopBackground = true;
      DisableTelemetry = true;
      HttpsOnlyMode = "force_enabled";
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

      "3rdparty".Extensions = {
        "uBlock0@raymondhill.net" = {
          toOverwrite = {
            filters = [
              # https://jarv.is/notes/cloudflare-dns-archive-is-blocked/
              "archive.is"

              # spamming github
              "codecrafters.io"

              # no.
              "news.ycombinator.com"

              # 2024-01-02 https://lastfm-iceberg.dawdle.space
              "@@||ws.audioscrobbler.com^"
            ];
            filterLists = [
              "user-filters"
              "ublock-filters"
              "ublock-badware"
              "ublock-privacy"
              "ublock-quick-fixes"
              "ublock-unbreak"
              "easylist"
              "adguard-generic"
              "easyprivacy"
              "adguard-spyware"
              "adguard-spyware-url"
              "block-lan"
              "urlhaus-1"
              "curben-phishing"
              "plowe-0"
              "dpollock-0"
              "fanboy-cookiemonster"
              "ublock-cookies-easylist"
              "fanboy-social"
              "fanboy-thirdparty_social"
              "easylist-chat"
              "easylist-newsletters"
              "easylist-notifications"
              "easylist-annoyances"
              "adguard-mobile-app-banners"
              "adguard-other-annoyances"
              "adguard-popup-overlays"
              "adguard-widgets"
              "ublock-annoyances"
            ];
          };
        };
      };
    };
  };

  patch.json-merge.".mozilla/firefox/1a0nke3z.default/browser-extension-data/wayback_machine@mozilla.org/storage.js" =
    {
      agreement = true;
      private_mode_setting = true;
    };
}

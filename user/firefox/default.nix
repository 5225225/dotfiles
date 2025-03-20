{
  pkgs,
  lib,
  inputs,
  ...
}:
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
        # keep-sorted start
        fa.bandcamp-player-volume-control
        fa.batchcamp
        fa.darkreader
        fa.decentraleyes
        fa.indie-wiki-buddy
        fa.keepassxc-browser
        fa.sidebery
        fa.sponsorblock
        fa.streetpass-for-mastodon
        fa.stylus
        fa.ublock-origin
        fa.violentmonkey
        fa.wayback-machine
        # keep-sorted end
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

      search = {
        default = "ddg-with-settings";
        privateDefault = "ddg-with-settings";
        force = true;
        engines = {
          ddg-with-settings = {
            icon = pkgs.fetchurl {
              url = "https://duckduckgo.com/favicon.ico";
              hash = "sha256-2ZT4BrHkIltQvlq2gbLOz4RcwhahmkMth4zqPLgVuv0=";
            };
            name = "DDG";
            urls = [
              {
                template = "https://duckduckgo.com";
                params =
                  let
                    mkParam = name: value: {
                      inherit name;
                      inherit value;
                    };
                  in
                  [
                    (mkParam "q" "{searchTerms}")
                    (mkParam "kl" "uk-en")
                    (mkParam "kp" "-2")
                    (mkParam "kav" "1")
                    (mkParam "k1" "-1")
                    (mkParam "kaj" "m")
                    (mkParam "kat" "-1")
                    (mkParam "kv" "-1")
                    (mkParam "kax" "-1")
                    (mkParam "kaq" "-1")
                    (mkParam "kak" "-1")
                    (mkParam "kap" "-1")
                    (mkParam "kao" "-1")
                    (mkParam "kau" "-1")
                    (mkParam "kpsp" "-1")
                    (mkParam "kbg" "-1")
                    (mkParam "kbe" "0")
                  ];
              }
            ];
          };

          bing.metaData.hidden = true;
          google.metaData.hidden = true;
          ddg.metaData.hidden = true;
          ebay-uk.metaData.hidden = true;
          wikipedia.metaData.hidden = true;
        };
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

      Preferences =
        let
          mkLockedPref = value: {
            Value = value;
            Status = "locked";
          };
        in
        {
          # fuck the fuck off
          "browser.ml.chat.enabled" = (mkLockedPref false);
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

  #patch.json-merge.".mozilla/firefox/1a0nke3z.default/browser-extension-data/wayback_machine@mozilla.org/storage.js" =
  #  {
  #    agreement = true;
  #    private_mode_setting = true;
  #  };
}

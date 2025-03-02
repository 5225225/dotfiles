{
  config,
  pkgs,
  nix-index-database,
  agenix,
  nixvim,
  base16,
  scheme,
  ...
}:
{
  imports = [
    # keep-sorted start
    ./agenix.nix
    ./beets/beets.nix
    ./direnv
    ./eza.nix
    ./fd.nix
    ./firefox
    ./fish
    ./foot.nix
    ./git/git.nix
    ./hledger
    ./htop.nix
    ./imv.nix
    ./jq.nix
    ./listenbrainz-mpd.nix
    ./mako.nix
    ./mpd.nix
    ./mpv/mpv.nix
    ./ncmpcpp.nix
    ./neovim.nix
    ./obs
    ./qalc
    ./ripgrep.nix
    ./rofi
    ./scripts/dmenu_mpd/default.nix
    ./scripts/mpv-open-clipboard.nix
    ./scripts/quicknote.nix
    ./scripts/rofi_swayws/rofi_swayws.nix
    ./scripts/wcwd.nix
    ./sway/sway.nix
    ./waybar
    ./xonotic/xonotic.nix
    # keep-sorted end
    nix-index-database.hmModules.nix-index
    agenix.homeManagerModules.age
    nixvim.homeManagerModules.nixvim
    base16.homeManagerModule
  ];

  inherit scheme;

  xdg.enable = true;

  xdg.mimeApps = {
    enable = true;
    associations.added = {
      "x-scheme-handler/tg" = [
        "org.telegram.desktop.desktop"
        "userapp-Telegram Desktop-5YQVL2.desktop"
      ];
      "x-scheme-handler/tonsite" = "org.telegram.desktop.desktop";
    };
    defaultApplications = {
      "x-scheme-handler/tg" = "userapp-Telegram Desktop-5YQVL2.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "application/pdf" = "firefox.desktop";
      "text/html" = "firefox.desktop";
      "application/xhtml+xml" = "firefox.desktop";
      "x-scheme-handler/discord-378612438200877056" = "discord-378612438200877056.desktop";
      "x-scheme-handler/tonsite" = "org.telegram.desktop.desktop";
    };
  };

  home = {
    sessionVariables = {
      LESSHISTFILE = "/dev/null";
      CARGO_HOME = "${config.xdg.dataHome}/cargo/";
      DOTNET_CLI_TELEMETRY_OPTOUT = "1";
      PYTHONPYCACHEPREFIX = "${config.xdg.cacheHome}/python";
      PYTHONUSERBASE = "${config.xdg.dataHome}/python";
      GRADLE_USER_HOME = "${config.xdg.dataHome}/gradle";
      GNUPGHOME = "${config.xdg.dataHome}/gnupg";
      KANI_HOME = "${config.xdg.dataHome}/kani";
      MINETEST_USER_PATH = "${config.xdg.dataHome}/minetest";
      RUSTUP_HOME = "${config.xdg.dataHome}/rustup";
    };

    # Home Manager needs a bit of information about you and the paths it should
    # manage.
    username = "fivie";
    homeDirectory = "/home/fivie";
  };

  programs.bash.historyFile = "${config.xdg.stateHome}/bash/history";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # keep-sorted start ignore_prefixes=(
    pkgs.atool
    pkgs.audacity
    pkgs.binwalk
    pkgs.blender
    (pkgs.buku.override { withServer = true; })
    pkgs.chromium
    pkgs.dfc
    pkgs.diffoscope
    pkgs.dino
    pkgs.dogdns
    pkgs.element-desktop
    pkgs.ffmpeg-full
    pkgs.file
    pkgs.flac
    pkgs.fossil
    pkgs.freerdp
    pkgs.ghidra
    pkgs.gimp
    pkgs.hyperfine
    pkgs.imagemagick
    pkgs.imhex
    pkgs.keepassxc
    pkgs.libnotify
    pkgs.libreoffice-fresh
    pkgs.libwebp
    pkgs.links2
    pkgs.man-pages
    pkgs.man-pages-posix
    pkgs.mindustry
    pkgs.moreutils
    pkgs.mpc-cli
    pkgs.mpdscribble
    pkgs.ncdu
    pkgs.nix-diff
    pkgs.openrct2
    pkgs.pavucontrol
    pkgs.pngcrush
    pkgs.prismlauncher
    pkgs.pv
    pkgs.python3
    pkgs.sgt-puzzles
    pkgs.shattered-pixel-dungeon
    pkgs.signal-desktop
    pkgs.sqlite
    pkgs.srb2kart
    pkgs.starsector
    pkgs.stress
    pkgs.tamzen
    pkgs.telegram-desktop
    pkgs.terminus_font
    pkgs.tor-browser-bundle-bin
    pkgs.unrar
    pkgs.unzip
    pkgs.vdrift
    pkgs.wget
    pkgs.whois
    pkgs.wl-clipboard
    pkgs.xdg-utils
    pkgs.zip
    pkgs.zola
    # keep-sorted end
  ];

  fonts.fontconfig.enable = true;

  gtk = {
    enable = true;
    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
    theme.package = pkgs.nordic;
    theme.name = "Nordic";
  };

  home.pointerCursor = {
    package = pkgs.adwaita-icon-theme;
    name = "Adwaita";
    gtk.enable = true;

    size = 16;
  };

  systemd.user.startServices = "sd-switch";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  manual = {
    html.enable = true;
    manpages.enable = true;
  };

  services.udiskie.enable = true;
}

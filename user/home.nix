{ config, pkgs, nix-colors, lib, base16-vim, nix-index-database, idris2-nvim, agenix, vim-capnp, ... }:

{
  imports = [
    ./agenix.nix
    ./beets/beets.nix
    ./direnv.nix
    ./firefox
    ./fish
    ./foot.nix
    ./git/git.nix
    ./hledger
    ./listenbrainz-mpd.nix
    ./mpv/mpv.nix
    ./obs
    ./rofi
    ./scripts/dmenu_mpd/default.nix
    ./scripts/mpv-open-clipboard.nix
    ./scripts/quicknote.nix
    ./scripts/rofi_swayws/rofi_swayws.nix
    ./scripts/wcwd.nix
    ./sway/sway.nix
    ./waybar
    ./xonotic/xonotic.nix
    ./ncmpcpp.nix
    ./mako.nix
    ./mpd.nix
    ./neovim.nix
    nix-colors.homeManagerModules.default
    nix-index-database.hmModules.nix-index
    agenix.homeManagerModules.age
  ];

  colorScheme = nix-colors.colorSchemes.tube;

  xdg.enable = true;

  xdg.mimeApps = {
    enable = true;
    associations.added = {
      "x-scheme-handler/tg" = [ "org.telegram.desktop.desktop" "userapp-Telegram Desktop-5YQVL2.desktop" ];
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
    username = "jess";
    homeDirectory = "/home/jess";
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
  home.packages = with pkgs; [
    atool
    audacity
    binwalk
    blender
    chromium
    dfc
    diffoscope
    dino
    dogdns
    element-desktop
    eza
    fd
    ffmpeg-full
    file
    flac
    fossil
    freerdp
    ghidra
    gimp
    git
    htop
    hyperfine
    imagemagick
    imhex
    imv
    jq
    keepassxc
    libnotify
    libqalculate
    libreoffice-fresh
    libwebp
    links2
    maim
    man-pages
    man-pages-posix
    mindustry
    moreutils
    mpc-cli
    mpdscribble
    ncdu
    nicotine-plus
    openrct2
    pavucontrol
    pngcrush
    prismlauncher
    pv
    python3
    ripgrep
    sgt-puzzles
    shattered-pixel-dungeon
    signal-desktop
    sqlite
    starsector
    stow
    stress
    tamzen
    telegram-desktop
    terminus_font
    thunderbird
    tor-browser-bundle-bin
    unrar
    unzip
    vdrift
    wget
    whois
    wl-clipboard
    xdg-utils
    yt-dlp
    zip
    zola
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
    ".background-image".source = data/wallpaper.png;
  };

  home.sessionVariables = {
    # EDITOR = "emacs";
  };

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
}

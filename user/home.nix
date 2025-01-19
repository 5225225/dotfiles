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
    ./zsh/zsh.nix
    nix-colors.homeManagerModules.default
    nix-index-database.hmModules.nix-index
    agenix.homeManagerModules.age
  ];

  colorScheme = nix-colors.colorSchemes.tube;

  xdg.enable = true;

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

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/jess/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  services = {
    mpd = {
      enable = true;
      musicDirectory = "/home/jess/media/music";
      extraConfig = ''
        audio_output {
          type  "pulse"
          name  "My Pulse Output"
        }

        replaygain "auto"

        max_output_buffer_size "32768"
        max_command_list_size "8192"
        auto_update "yes"
      '';
    };
  };

  programs = {
    ncmpcpp = {
      enable = true;
      bindings = [
        {
          key = "l";
          command = "next_column";
        }
        {
          key = "h";
          command = "previous_column";
        }
        {
          key = "j";
          command = "scroll_down";
        }
        {
          key = "k";
          command = "scroll_up";
        }
        {
          key = "l";
          command = "show_lyrics";
        }
      ];

      settings = {
        song_list_format = "{%a - }{%t}|{$8%f$9}$R{$3(%l)$9}";
        song_status_format = ''{{%a{ "%b"{ (%y)}} - }{%t}}|{%f}'';
        song_library_format = "{%n - }{%t}|{%f}";
        current_item_prefix = "$(cyan)$r";
        current_item_suffix = "$/r$(end)";
        current_item_inactive_column_prefix = "$b";
        current_item_inactive_column_suffix = "$/b$(end)";
        song_columns_list_format =
          "(20)[green]{a} (50)[red]{t|f:Title} (20)[cyan]{b} (7f)[magenta]{l}";
        playlist_show_remaining_time = "yes";
        playlist_separate_albums = "yes";
        show_duplicate_tags = "no";
        progressbar_look = "-* ";
        user_interface = "alternative";
        media_library_primary_tag = "album_artist";
        tags_separator = " | ";
        main_window_color = "blue";
        lyrics_directory = "${config.xdg.stateHome}/lyrics";
      };
    };

    neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
      plugins = with pkgs.vimPlugins; [
        rust-vim
        vim-wayland-clipboard
        vim-nix
        vim-ledger
        nvim-lspconfig
        nui-nvim
        vim-glsl
        (pkgs.vimUtils.buildVimPlugin {
          name = "vim-capnp";
          src = vim-capnp;
        })
        (pkgs.vimUtils.buildVimPlugin {
          name = "base16-vim";
          src = base16-vim;
        })
        (pkgs.vimUtils.buildVimPlugin {
          name = "idris2-nvim";
          src = idris2-nvim;
        })
      ];
      extraLuaConfig = ''
        require('idris2').setup({})
      '';
      extraConfig = ''
        set nobackup
        set noswapfile
        filetype plugin indent off
        set mouse=

        set expandtab
        set shiftwidth=4
        set softtabstop=4
        set autoindent
        set smarttab

        set number

        set termguicolors
        let tinted_background_transparent=1
        set background=dark
        colorscheme base16-tube

        filetype plugin on
        syntax on

        set tw=99

        set modeline
        set modelines=5

        set backspace=indent,eol,start

        set incsearch
        set autoread

        set laststatus=2

        set smartcase

        set spell
        set wrapscan

        set clipboard^=unnamed

        set ttimeout
        set ttimeoutlen=50

        set ruler
        set showcmd
        set wildmenu

        set gdefault

        set foldmethod=syntax
        set foldnestmax=1

        let g:netrw_dirhistmax=0

        let &t_SI = "\<esc>[6 q"
        let &t_SR = "\<esc>[4 q"
        let &t_EI = "\<esc>[2 q"
      '';
    };
  };

  fonts.fontconfig.enable = true;

  services.mako = {
    font = "Tamzen 13";
    layer = "overlay";
    actions = false;
    width = 500;

    anchor = "bottom-center";
    margin = "10";
    defaultTimeout = 5000;
    enable = true;
    backgroundColor = "#000000D0";
    borderRadius = 5;
    borderSize = 0;
  };

  gtk = {
    enable = true;
    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
    theme.package = pkgs.nordic;
    theme.name = "Nordic";
  };

  systemd.user.startServices = "sd-switch";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}

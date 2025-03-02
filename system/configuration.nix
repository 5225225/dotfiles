# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  lib,
  inputs,
  self,
  ...
}:
{
  imports = [
    ./agenix.nix
    ./borgbackup.nix
    ./earlyoom.nix
    ./hardware-configuration.nix
    ./syncthing.nix
    ./yarr.nix
    ./fishnet.nix
    ./slskd.nix
    inputs.nix-index-database.nixosModules.nix-index
    inputs.agenix.nixosModules.default
    inputs.lix-module.nixosModules.default
    inputs.home-manager.nixosModules.home-manager
    inputs.base16.nixosModule
  ];

  scheme = "${inputs.tt-schemes}/base16/tube.yaml";

  # Bootloader.
  boot = {
    loader = {
      systemd-boot.enable = true;
      systemd-boot.netbootxyz.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelParams = [
      "iommu=soft"
      "rcu_nocbs=0-15"
    ];
    initrd.systemd.enable = true;
    tmp = {
      cleanOnBoot = true;
    };
  };

  systemd.enableStrictShellChecks = true;

  networking = {
    hostName = "iridium";

    # Enable networking
    networkmanager.enable = true;
    networkmanager.dns = "systemd-resolved";
  };

  networking.nameservers = [
    "1.1.1.1"
    "1.0.0.1"
  ];

  services = {
    resolved = {
      enable = true;
      dnssec = "true";

      # This is needed to not use local DNS anyways.
      # See https://wiki.archlinux.org/title/Systemd-resolved#Manually
      # > Without the Domains=~. option in resolved.conf(5), systemd-resolved might use the per-link
      # > DNS servers, if any of them set Domains=~. in the per-link configuration.
      domains = [ "~." ];

      fallbackDns = [
        "1.1.1.1"
        "1.0.0.1"
      ];
      dnsovertls = "true";
    };

    getty = {
      autologinUser = "fivie";
      autologinOnce = true;
    };

    udisks2.enable = true;

    tailscale.enable = true;
  };

  # Set your time zone.
  time.timeZone = "Europe/London";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  programs = {
    fish.enable = true;
    dconf.enable = true;
    steam.enable = true;
    command-not-found.enable = false;
  };

  # Configure console keymap
  console.keyMap = "uk";

  users = {
    mutableUsers = false;
    users.root.hashedPassword = config.users.users.fivie.hashedPassword;
    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.fivie = {
      isNormalUser = true;
      description = "5225225";
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
      shell = pkgs.bash;
      # yes, you can crack this
      # no, i don't use it anywhere important, i do not care.
      hashedPassword = "$y$j9T$nLW2y6cB.3dWfnd/PXcMT0$7t4FTeq3t3hz1iVlfLtwrZTc.sWYhKqL1Gq.GyDWk5/";
      packages = [ ];
      uid = 1000;
    };
  };

  nix = {
    channel.enable = false;

    settings = {
      auto-optimise-store = true;
      extra-experimental-features = [
        "flakes"
        "nix-command"
        "ca-derivations"
      ];
      use-xdg-base-directories = true;
      keep-outputs = true;
      keep-derivations = true;
    };
    daemonCPUSchedPolicy = "idle";
    daemonIOSchedClass = "idle";
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "steam"
      "steam-unwrapped"
      "starsector"
      "unrar"
    ];

  nixpkgs.config.permittedInsecurePackages = [ ];

  environment = {
    # List packages installed in system profile. To search, run:
    # $ nix search wget
    shells = [ pkgs.zsh ];

    # This is to work around incomplete completions for fish
    # In *theory* home-manager should help with this.. but it doesn't!
    # see https://github.com/nix-community/home-manager/issues/5119
    # and https://discourse.nixos.org/t/fish-shell-and-manual-page-completion-nixos-home-manager/15661/4
    pathsToLink = [ "/share/fish" ];

    sessionVariables.NIXOS_OZONE_WL = "1";

    systemPackages = [
      pkgs.adwaita-icon-theme
      pkgs.vimHugeX
      pkgs.man-pages
      pkgs.man-pages-posix
      pkgs.git
      inputs.agenix.packages.x86_64-linux.default
    ];
  };

  fonts.packages = [
    pkgs.noto-fonts
    pkgs.noto-fonts-cjk-sans
    pkgs.noto-fonts-extra
    pkgs.noto-fonts-color-emoji
    pkgs.tamsyn
    pkgs.ocr-a
  ];

  security = {
    rtkit.enable = true;
    polkit.enable = true;

    # https://github.com/NixOS/nixpkgs/issues/361592#issuecomment-2516342739
    pam.services.systemd-run0 = {
      setEnvironment = true;
      pamMount = false;
    };
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  documentation.dev.enable = true;

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  system = {
    stateVersion = "23.05"; # Did you read the comment?
    nixos.label = "cfg:${
      builtins.substring 0 10 config.system.configurationRevision
    }${config.system.nixos.versionSuffix}";
    rebuild.enableNg = true;
    configurationRevision = self.rev or "dirty";
  };

  xdg.portal = {
    enable = true;
    config.common.default = "wlr";

    wlr = {
      enable = true;
    };
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.fivie = import ../user/home.nix;
  };

  home-manager.extraSpecialArgs = {
    inherit (inputs)
      base16-vim
      vim-capnp
      nix-index-database
      agenix
      nixvim
      firefox-addons
      nixos-unstable-small
      base16
      tt-schemes
      ;

    scheme = config.scheme;
  };

  nix.gc.automatic = true;

  environment.etc."nixos/flake.nix".source = "/home/fivie/dotfiles/flake.nix";
}

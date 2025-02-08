# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ config
, pkgs
, lib
, ...
}: {
  imports = [
    ./agenix.nix
    ./borgbackup.nix
    ./earlyoom.nix
    ./hardware-configuration.nix
    ./syncthing.nix
  ];

  # Bootloader.
  boot = {
    loader.systemd-boot.enable = true;
    loader.systemd-boot.netbootxyz.enable = true;
    loader.efi.canTouchEfiVariables = true;
    kernelParams = [ "iommu=soft" "rcu_nocbs=0-15" ];
    initrd.systemd.enable = true;
  };

  networking = {
    hostName = "iridium";

    firewall = {
      allowedTCPPorts = [ 51712 51713 ]; # soulseek
    };
    # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Enable networking
    networkmanager.enable = true;
    networkmanager.dns = "systemd-resolved";
  };

  networking.nameservers = [
    "1.1.1.1"
    "1.0.0.1"
  ];

  services.resolved = {
    enable = true;
    dnssec = "true";
    fallbackDns = [
      "1.1.1.1"
      "1.0.0.1"
    ];
    dnsovertls = "true";
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
  };

  # Configure console keymap
  console.keyMap = "uk";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.fivie = {
    isNormalUser = true;
    description = "fivie";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.bash;
    # yes, you can crack this
    # no, i don't use it anywhere important, i do not care.
    initialHashedPassword = "$y$j9T$nLW2y6cB.3dWfnd/PXcMT0$7t4FTeq3t3hz1iVlfLtwrZTc.sWYhKqL1Gq.GyDWk5/";
    packages = with pkgs; [ ];
    uid = 1000;
  };

  nix = {
    channel.enable = false;

    settings = {
      auto-optimise-store = true;
      extra-experimental-features = [ "flakes" "nix-command" "ca-derivations" ];
      use-xdg-base-directories = true;
    };
    daemonCPUSchedPolicy = "idle";
    daemonIOSchedClass = "idle";
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "steam"
      "steam-unwrapped"
      "starsector"
      "unrar"
    ];

  nixpkgs.config.permittedInsecurePackages = [
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.shells = with pkgs; [ zsh ];

  # This is to work around incomplete completions for fish
  # In *theory* home-manager should help with this.. but it doesn't!
  # see https://github.com/nix-community/home-manager/issues/5119
  # and https://discourse.nixos.org/t/fish-shell-and-manual-page-completion-nixos-home-manager/15661/4
  environment.pathsToLink = [ "/share/fish" ];

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  environment.systemPackages = with pkgs; [
    adwaita-icon-theme
    vimHugeX
    man-pages
    man-pages-posix
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #  wget
  ];

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-extra
    noto-fonts-color-emoji
    tamsyn
    ocr-a
  ];

  security.rtkit.enable = true;
  security.polkit.enable = true;

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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

  system.nixos.label = builtins.substring 0 10 config.system.configurationRevision + "-" + config.system.nixos.version;

  xdg.portal = {
    enable = true;
    config.common.default = "wlr";

    wlr = {
      enable = true;
    };
  };

  environment.etc."nixos/flake.nix".source = "/home/fivie/dotfiles/flake.nix";
}

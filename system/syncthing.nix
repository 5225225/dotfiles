{
  services.syncthing = {
    enable = true;
    user = "fivie";
    dataDir = "/home/fivie/media/syncthing";
    configDir = "/home/fivie/.config/syncthing";
  };

  # https://docs.syncthing.net/users/firewall.html
  # we don't allow webgui through the firewall
  networking.firewall.allowedTCPPorts = [ 22000 ];
  networking.firewall.allowedUDPPorts = [
    22000
    21027
  ];
}

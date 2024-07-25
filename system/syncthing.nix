{
  services.syncthing = {
    enable = true;
    user = "jess";
    dataDir = "/home/jess/media/syncthing";
    configDir = "/home/jess/.config/syncthing";
  };

  # https://docs.syncthing.net/users/firewall.html
  # we don't allow webgui through the firewall
  networking.firewall.allowedTCPPorts = [ 22000 ];
  networking.firewall.allowedUDPPorts = [ 22000 21027 ];
}

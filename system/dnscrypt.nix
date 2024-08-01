{
  services.dnscrypt-proxy2 = {
    enable = true;
    settings = {
      ipv6_servers = false;

      require_dnssec = true;
      require_nolog = true;
      require_nofilter = true;


      sources.public-resolvers = {
        urls = [
          "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
          "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
        ];
        cache_file = "/var/lib/dnscrypt-proxy/public-resolvers.md";
        minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
      };

      # If you want, choose a specific set of servers that come from your sources.
      # Here it's from https://github.com/DNSCrypt/dnscrypt-resolvers/blob/master/v3/public-resolvers.md
      # If you don't specify any, dnscrypt-proxy will automatically rank servers
      # that match your criteria and choose the best one.
      # server_names = [ ... ];
    };
  };

  systemd.services.dnscrypt-proxy2.serviceConfig = {
    StateDirectory = "dnscrypt-proxy";
    # If you're trying to set up persistence with dnscrypt-proxy2 and it isn't working
    # because of permission issues, try the following:
    # StateDirectory = lib.mkForce "";
    # ReadWritePaths = "/var/lib/dnscrypt-proxy"; # Cache directory for dnscrypt-proxy2, persist this
  };
}

{ pkgs, config, ... }:
{
  services.freshrss = {
    enable = true;
    authType = "none";
    baseUrl = "https://iridium.tailb3553.ts.net";
    webserver = "caddy";
    extensions =
      let
        ext = pkgs.freshrss-extensions;
      in
      [ ext.auto-ttl ];
  };

  services.caddy.virtualHosts.${config.services.freshrss.virtualHost} = {
    hostName = "iridium.tailb3553.ts.net";
    listenAddresses = [ "0.0.0.0" ];
  };

  services.tailscale.permitCertUid = config.services.caddy.user;

  networking.firewall.trustedInterfaces = [ "tailscale0" ];
}

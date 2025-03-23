{ config, ... }:
{
  services.freshrss = {
    enable = true;
    authType = "none";
    baseUrl = "http://127.0.0.1";
  };

  services.nginx.virtualHosts.${config.services.freshrss.virtualHost}.listen = [
    {
      addr = "127.0.0.1";
      port = 80;
    }
  ];
}

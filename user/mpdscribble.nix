{ config, ... }:
{
  services.mpdscribble = {
    enable = true;
    endpoints = {
      "last.fm" = {
        passwordFile = config.age.secrets.lastfm.path;
        username = "lfm5225225";
      };
    };
  };
}

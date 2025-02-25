{ config, ... }:
{
  services.listenbrainz-mpd = {
    enable = true;
    settings = {
      submission = {
        token_file = config.age.secrets.listenbrainz-mpd-token.path;
      };
    };
  };
}

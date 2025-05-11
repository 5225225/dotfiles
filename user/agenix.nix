{ config, ... }:
{
  age.secrets.listenbrainz-mpd-token = {
    file = ../secrets/listenbrainz-mpd-token.age;
    # home-manager agenix would emit
    # token_file = "$XDG_RUNTIME_DIR/agenix/listenbrainz-mpd-token"
    # which listenbrainz-mpd doesn't like. manually specify a reasonable path here.
    path = "${config.xdg.configHome}/listenbrainz-mpd/token";
  };
  age.secrets.lastfm = {
    file = ../secrets/lastfm.age;
    # TODO: move these somewhere more reasonable
    path = "${config.xdg.configHome}/lastfm-token";
  };
}

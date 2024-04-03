{ pkgs, config, ... }: {
  services.listenbrainz-mpd = {
    enable = true;
    settings = {
      submission = {
        token_file = "${config.xdg.configHome}/listenbrainz-mpd/token";
      };
    };
  };
}

{ config, pkgs, ... }:
{
  programs.beets = {
    enable = true;
    package = pkgs.beets-unstable.override {
      pluginOverrides = {
        alternatives = {
          enable = true;
          propagatedBuildInputs = [ pkgs.beetsPackages.alternatives ];
        };
        copyartifacts = {
          enable = true;
          propagatedBuildInputs = [ pkgs.beetsPackages.copyartifacts ];
        };
      };
    };
    settings = {
      directory = "~/media/music";
      library = "~/media/.beets_library.blb";
      import = {
        write = true;
        copy = true;
        languages = "en";
        timid = false;
      };
      match.strong_rec_thresh = 0.01;
      plugins = [
        #keep-sorted start
        "alternatives"
        "badfiles"
        "convert"
        "copyartifacts"
        "duplicates"
        "edit"
        "embedart"
        "fetchart"
        "fish"
        "fromfilename"
        "ftintitle"
        "fuzzy"
        "info"
        "inline"
        "lastimport"
        "limit"
        "lyrics"
        "mbsubmit"
        "mbsync"
        "missing"
        "permissions"
        "replaygain"
        "rewrite"
        "scrub"
        "types"
        "mbcollection"
        #keep-sorted end
      ];
      lastfm.user = "lfm5225225";
      embedart.auto = false;
      alternatives = {
        phone = {
          directory = "${config.home.homeDirectory}/media/syncthing/music";
          formats = "opus";
          query = "on_phone:true";
        };
      };
      replaygain = {
        auto = true;
        backend = "gstreamer";
        overwrite = true;
      };
      badfiles.check_on_import = true;
      badfiles.commands = {
        ogg = "${pkgs.opusTools}/bin/opusinfo -q";
        opus = "${pkgs.opusTools}/bin/opusinfo -q";
      };
      asciify_paths = true;
      ui.color = true;
      ui.colors = {
        text_success = "green";
        text_warning = "yellow";
        text_error = "red";
        text_highlight = "red";
        text_highlight_minor = "lightgray";
        action_default = "turquoise";
        action = "blue";
      };
      musicbrainz = {
        user = "5225225";
        # lol not putting that in my config
        # have to put it in here to satisfy the tests tho
        pass = "";
      };
      mbcollection = {
        collection = "1b914f64-c83e-4369-91d6-cfbc912e551f";
        remove = true;
      };
      original_date = true;
      convert = {
        never_convert_lossy_files = false;
        format = "opus";
        dest = "${config.home.homeDirectory}/media/syncthing/music";
        copy_album_art = true;
        album_art_maxwidth = 1000;
        embed = false;
        formats = {
          opus = "ffmpeg -i $source -y -vn -acodec libopus -ab 64k $dest";
        };
      };
      types.on_phone = "bool";
      edit.itemfields = [
        "track"
        "title"
        "artist"
        "album"
        "year"
        "month"
        "day"
      ];
      edit.albumfields = [
        "album"
        "albumartist"
        "year"
        "month"
        "day"
      ];
      paths = {
        default = "$albumartist/%if{$year,$year - }$album%aunique{}/%if{$track,$track - }$title";
        singleton = "$albumartist/Singles/$title";
        comp = "Various Artists/$album%aunique{}/%if{$track,$track - }$title";
      };
    };
    #home.packages = [ pkgs.beetsPackages.alternatives ];

    #xdg.configFile."beets/config.yaml" = {
    #  enable = true;
    #  source = ./config.yaml;
    #};
  };

  xdg.configFile."fish/completions/beet.fish" = {
    enable = true;

    source =
      pkgs.runCommandLocal "beetscomp"
        { config = (pkgs.formats.yaml { }).generate "beets-config" config.programs.beets.settings; }
        ''
          # prevent beets from looking in $HOME
          export BEETSDIR="/tmp"

          ${config.programs.beets.package}/bin/beet -l /tmp/db -c "$config" fish --output "$out"
        '';
  };
}

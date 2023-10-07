{ pkgs, ... }: {
  programs.beets = {
    enable = true;
    package = pkgs.beets-unstable.override {
      pluginOverrides = {
        alternatives = {
          enable = true;
          propagatedBuildInputs = [ pkgs.beetsPackages.alternatives ];
        };
        # We need to include the existing pluginOverrides here
        limit = { builtin = true; };
      };
    };
    settings = {
      directory = "~/media/music";
      library = "~/media/music/library.blb";
      import = {
        write = true;
        copy = true;
        languages = "en";
        timid = false;
        log = "~/media/music/beets-import.log";
      };
      match.strong_rec_thresh = 1.0e-2;
      plugins = [
        "alternatives"
        "badfiles"
        "convert"
        "duplicates"
        "edit"
        "embedart"
        "fetchart"
        "fromfilename"
        "ftintitle"
        "fuzzy"
        "info"
        "inline"
        "limit"
        "lyrics"
        "mbsync"
        "missing"
        "permissions"
        "replaygain"
        "rewrite"
        "scrub"
        "types"
      ];
      alternatives.phone = {

        directory = "/home/jess/media/syncthing/music";
        formats = "opus";
        query = "on_phone:true";
      };
      embedart.auto = false;
      replaygain = {
        auto = true;
        backend = "gstreamer";
        overwrite = true;
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
      original_date = true;
      convert = {
        never_convert_lossy_files = false;
        format = "opus";
        dest = "~/media/syncthing/music";
        threads = "1";
        quiet = true;
        copy_album_art = true;
        embed = true;
        formats = {
          opus = "ffmpeg -i $source -y -vn -acodec libopus -ab 64k $dest";
          ogg = "ffmpeg -i $source -y -vn -acodec libvorbis -aq 2 $dest";
        };
      };
      types.on_phone = "bool";
      edit.itemfields =
        [ "track" "title" "artist" "album" "year" "month" "day" ];
      edit.albumfields = [ "album" "albumartist" "year" "month" "day" ];
      paths = {

        default =
          "$albumartist/%if{$year,$year - }$album%aunique{}/%if{$track,$track - }$title";
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
}

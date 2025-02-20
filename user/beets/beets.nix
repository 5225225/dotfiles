{
  config,
  pkgs,
  ...
}: {
  programs.beets = {
    enable = true;
    package = pkgs.beets-unstable.override {
      pluginOverrides = {
        alternatives = {
          enable = true;
          propagatedBuildInputs = [pkgs.beetsPackages.alternatives];
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
      edit.itemfields = ["track" "title" "artist" "album" "year" "month" "day"];
      edit.albumfields = ["album" "albumartist" "year" "month" "day"];
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
}

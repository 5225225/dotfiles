{ pkgs, ... }: {
  programs.beets = {
    enable = true;
    package = pkgs.beets-unstable;
    settings = {
      directory = "~/media/music";
      library = "~/media/.beets_library.blb";
      import = {
        write = true;
        copy = true;
        languages = "en";
        timid = false;
        log = "~/media/music/beets-import.log";
      };
      match.strong_rec_thresh = 1.0e-2;
      plugins = [
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
        "mbsubmit"
        "mbsync"
        "missing"
        "permissions"
        "replaygain"
        "rewrite"
        "scrub"
        "types"
      ];
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
        dest = "/home/jess/media/syncthing/music";
        copy_album_art = true;
        album_art_maxwidth = 750;
        embed = true;
        formats = {
          opus = "ffmpeg -i $source -y -vn -acodec libopus -ab 64k $dest";
        };
      };
      rewrite = {
        "albumartist Cavetown \\+ Simi" = "Cavetown";
        "albumartist Cavetown \\+ chloe moriondo" = "Cavetown";

        "albumartist Chumbawamba / A State of Mind" = "Chumbawamba";
        "albumartist Chumbawamba / Passion Killers" = "Chumbawamba";
        "albumartist Chumbawamba meets DiY" = "Chumbawamba";

        "albumartist Darius \\+ Rotteen" = "Darius";
        "albumartist Halley Hard Sound Unit 𓃚 𝕮𝖆𝖒𝖇𝖎𝖚𝖒, 𝕏𝕪𝕝𝕖𝕞, 🙴 𝓗𝓮𝓪𝓻𝓽𝔀𝓸𝓸𝓭" = "Halley Hard Sound Unit";
        "albumartist Hideaki Kobayashi & Daisuke Nomura" = "Hideaki Kobayashi";

        "albumartist Imagine Dragons featuring Kendrick Lamar" = "Imagine Dragons";
        "albumartist In Love With a Ghost feat\\. Snail’s House" = "In Love With a Ghost";
        "albumartist Jackal Queenston & NegaRen" = "Jackal Queenston";
        "albumartist JPEGMAFIA & Freaky" = "JPEGMAFIA";
        "albumartist Laura Les / 99jakes / Black Dresses" = "Laura Les";
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

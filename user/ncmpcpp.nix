{ config, ... }:
{
  programs.ncmpcpp = {
    enable = true;
    bindings = [
      {
        key = "l";
        command = "next_column";
      }
      {
        key = "h";
        command = "previous_column";
      }
      {
        key = "j";
        command = "scroll_down";
      }
      {
        key = "k";
        command = "scroll_up";
      }
      {
        key = "l";
        command = "show_lyrics";
      }
    ];

    settings = {
      song_list_format = "{%a - }{%t}|{$8%f$9}$R{$3(%l)$9}";
      song_status_format = ''{{%a{ "%b"{ (%y)}} - }{%t}}|{%f}'';
      song_library_format = "{%n - }{%t}|{%f}";
      current_item_prefix = "$(cyan)$r";
      current_item_suffix = "$/r$(end)";
      current_item_inactive_column_prefix = "$b";
      current_item_inactive_column_suffix = "$/b$(end)";
      song_columns_list_format =
        "(20)[green]{a} (50)[red]{t|f:Title} (20)[blue]{b} (7f)[magenta]{l}";
      playlist_show_remaining_time = "yes";
      playlist_separate_albums = "yes";
      show_duplicate_tags = "no";
      progressbar_look = "-* ";
      user_interface = "alternative";
      media_library_primary_tag = "album_artist";
      tags_separator = " | ";
      main_window_color = "blue";
      lyrics_directory = "${config.xdg.stateHome}/lyrics";
    };
  };
}

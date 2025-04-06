{ pkgs, config, ... }:
{
  programs.mpv = {
    enable = true;
    scripts =
      let
        s = pkgs.mpvScripts;
      in
      [
        s.autodeint
        s.memo
        s.quality-menu
        s.sponsorblock
        s.thumbfast
        s.uosc
      ];
    config = {
      cache-on-disk = true;
      demuxer-max-bytes = "2GiB";

      ytdl-format = "bestvideo[height<=1080]+bestaudio/best[height<=1080]/best";
      volume = 30;

      vo = "gpu-next";
      profile = "high-quality";

      save-position-on-quit = true;
      write-filename-in-watch-later-config = true;

      sub-ass-override = false;
      sub-blur = 0.3;
      sub-color = 0.95;
      sub-back-color = "0.0/0.8";
      sub-border-color = "0.05/0.05/0.03";
      sub-border-size = 2.2;
      sub-bold = true;
      sub-spacing = 0.6;
      sub-margin-x = 30;
      sub-margin-y = 36;
      sub-font-size = 43;
    };
  };

  home.file."${config.xdg.configHome}/mpv/script-opts/uosc.conf".source = ./uosc.conf;
}

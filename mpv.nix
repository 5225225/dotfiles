{ pkgs, ... }: {
  programs.mpv = {
    enable = true;
    scripts = with pkgs.mpvScripts; [
      autocrop
      autodeint
      youtube-quality
      sponsorblock
    ];
    config = {
      cache = "auto";
      demuxer-max-bytes = "512MiB";
      demuxer-readahead-secs = 1200;
      ytdl-format = "bestvideo[height<=1080]+bestaudio/best[height<=1080]/best";
      volume = 30;
      profile = "opengl-hq";
      scale = "ewa_lanczossharp";
      cscale = "ewa_lanczossharp";
      sub-ass-override = false;
      sub-blur = 0.3;
      sub-color = 0.95;
      sub-border-color = "0.05/0.05/0.03";
      sub-border-size = 2.2;
      sub-bold = true;
      sub-spacing = 0.6;
      sub-margin-x = 30;
      sub-margin-y = 36;
      sub-font-size = 43;
      sub-auto = "fuzzy";
    };
  };
}

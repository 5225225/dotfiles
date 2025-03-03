{ pkgs, ... }:
{
  programs.hyfetch = {
    enable = true;
    settings = {
      preset = "transgender";
      mode = "rgb";
      light_dark = "dark";
      lightness = 0.5;
      color_align = {
        mode = "horizontal";
        custom_colors = [ ];
        fore_back = null;
      };
      backend = "fastfetch";
      args = null;
      distro = "xenia2";
      pride_month_shown = [ ];
      pride_month_disable = true;
    };
  };

  home.packages = [ pkgs.fastfetch ];
}

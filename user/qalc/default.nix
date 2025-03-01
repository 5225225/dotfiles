{ pkgs, ... }:
{
  home.packages = [ pkgs.libqalculate ];
  xdg.configFile."qalculate/qalc.cfg".source = ./qalc.cfg;
}

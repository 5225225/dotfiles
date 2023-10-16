{ lib, pkgs, ... }:
let mod = "Mod1";
in {
  xsession.windowManager.i3 = {
    enable = true;
    config = {
      keybindings = lib.mkOptionDefault {
        "${mod}+Shift+numbersign" = "exec --no-startup-id ~/scripts/dmenu_mpd";
        "${mod}+Shift+p" = "exec --no-startup-id mpc toggle";
        "${mod}+Shift+bracketleft" = "exec --no-startup-id mpc prev";
        "${mod}+Shift+bracketright" = "exec --no-startup-id mpc next";
        "${mod}+Shift+minus" = "exec --no-startup-id mpc volume -10";
        "${mod}+Shift+plus" = "exec --no-startup-id mpc volume +10";

        "${mod}+Return" = "exec i3-sensible-terminal -cd $(xcwd)";
        "${mod}+d" = "exec rofi -show run";
        "${mod}+c" = ''
          exec rofi -show calc -modi calc -no-show-match -no-sort -hint-result "" -no-history'';

        "${mod}+h" = "focus left";
        "${mod}+j" = "focus down";
        "${mod}+k" = "focus up";
        "${mod}+l" = "focus right";

        "${mod}+Shift+h" = "move left";
        "${mod}+Shift+j" = "move down";
        "${mod}+Shift+k" = "move up";
        "${mod}+Shift+l" = "move right";

        "${mod}+b" = "split h";
      };
      workspaceAutoBackAndForth = true;
      gaps = {
        inner = 5;
        smartBorders = "on";
        smartGaps = true;
      };
      window = {
        hideEdgeBorders = "both";
        titlebar = false;
      };
      fonts = {
        names = [ "Terminus" ];
        style = "";
        size = 12;
      };
    };
  };
}

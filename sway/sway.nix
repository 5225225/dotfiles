{ pkgs, config, lib, ...}:
let 
  mod = config.wayland.windowManager.sway.config.modifier;
  rofi-package = config.programs.rofi.finalPackage;
  font = {
    names = ["Tamzen"];
    style = "Regular";
    size = 12.0;
  };
in
{
  wayland.windowManager.sway = {
    enable = true;
    config = {
      fonts = font;
      input = {
        "*" = {
          xkb_layout = "gb";
        };
      };
      output = {
        "*" = {
          bg = "${../data/wallpaper.png} fill";
        };
      };
      bars = [{
        fonts = font;
        mode = "dock";
        hiddenState = "hide";
        position = "bottom";
        statusCommand = "${pkgs.i3status}/bin/i3status";
        workspaceButtons = true;
        workspaceNumbers = true;
        trayOutput = "*";
        trayPadding = 2;
        extraConfig = "icon_theme \"Adwaita\"";
        colors = {
          background = "#000000D0";
          statusline = "#ffffff";
          separator = "#666666";
          focusedWorkspace = { background= "#4c7899D0"; border = "#285577"; text =  "#ffffff"; };
          activeWorkspace = { background= "#333333D0"; border = "#5f676a"; text =  "#ffffff"; };
          inactiveWorkspace = { background= "#333333D0"; border = "#222222"; text =  "#888888"; };
          urgentWorkspace = { background= "#2f343aD0"; border = "#900000"; text =  "#ffffff"; };
          bindingMode = { background= "#2f343aD0"; border = "#900000"; text =  "#ffffff"; };
        };
      }];
      window = {
        titlebar = false;
        hideEdgeBorders = "both";
      };
      workspaceAutoBackAndForth = true;
      gaps = {
        smartBorders = "on";
        smartGaps = true;
        inner = 5;
      };
      keybindings = lib.mkOptionDefault {
        "${mod}+d" = "exec ${rofi-package}/bin/rofi -show run";
        "${mod}+c" = "exec ${rofi-package}/bin/rofi -show calc -modi calc -no-show-match -no-sort -hint-result \"\" -no-history";

        "${mod}+grave" = "workspace back_and_forth";

        "${mod}+Shift+p" = "exec --no-startup-id ${pkgs.mpc-cli}/bin/mpc toggle";
        "${mod}+Shift+bracketleft" = "exec --no-startup-id ${pkgs.mpc-cli}/bin/mpc prev";
        "${mod}+Shift+bracketright" = "exec --no-startup-id ${pkgs.mpc-cli}/bin/mpc next";
        "${mod}+Shift+minus" = "exec --no-startup-id ${pkgs.mpc-cli}/bin/mpc volume -10";
        "${mod}+Shift+equal" = "exec --no-startup-id ${pkgs.mpc-cli}/bin/mpc volume +10";
        "${mod}+Shift+numbersign" = "exec --no-startup-id ~/scripts/dmenu_mpd";
        "${mod}+Return" = "exec ${pkgs.foot}/bin/foot -D \"$(wcwd)\"";

        "Print" = "exec ${pkgs.slurp}/bin/slurp | ${pkgs.grim}/bin/grim -g - - | ${pkgs.wl-clipboard}/bin/wl-copy";

        "${mod}+0" = "workspace number 10";
        "${mod}+Shift+0" = "move container to workspace number 10";

        "${mod}+f1" = "workspace number 11";
        "${mod}+f2" = "workspace number 12";
        "${mod}+f3" = "workspace number 13";
        "${mod}+f4" = "workspace number 14";
        "${mod}+f5" = "workspace number 15";
        "${mod}+f6" = "workspace number 16";
        "${mod}+f7" = "workspace number 17";
        "${mod}+f8" = "workspace number 18";
        "${mod}+f9" = "workspace number 19";
        "${mod}+f10" = "workspace number 20";
        "${mod}+f11" = "workspace number 21";
        "${mod}+f12" = "workspace number 22";

        "${mod}+Shift+f1" = "move container to workspace number 11";
        "${mod}+Shift+f2" = "move container to workspace number 12";
        "${mod}+Shift+f3" = "move container to workspace number 13";
        "${mod}+Shift+f4" = "move container to workspace number 14";
        "${mod}+Shift+f5" = "move container to workspace number 15";
        "${mod}+Shift+f6" = "move container to workspace number 16";
        "${mod}+Shift+f7" = "move container to workspace number 17";
        "${mod}+Shift+f8" = "move container to workspace number 18";
        "${mod}+Shift+f9" = "move container to workspace number 19";
        "${mod}+Shift+f10" = "move container to workspace number 20";
        "${mod}+Shift+f11" = "move container to workspace number 21";
        "${mod}+Shift+f12" = "move container to workspace number 22";
      };
    };
  };
}

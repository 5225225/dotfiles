{ pkgs, config, lib, ... }:
let
  mod = config.wayland.windowManager.sway.config.modifier;
  rofi-package = config.programs.rofi.finalPackage;
  font = {
    names = [ "Tamzen" ];
    style = "Regular";
    size = 12.0;
  };
  trans_bg = "#000000B0";
  trans_bg_focused = "#333333B0";
  blank_timeout = 60 * 10; # 10 minutes
in
{
  wayland.windowManager.sway = {
    enable = true;
    extraConfig = ''
      assign [app_id="firefox"] workspace number 1
      assign [app_id="thunderbird"] workspace number 11
      assign [app_id="org.telegram.desktop"] workspace number 12
      assign [app_id="Element"] workspace number 13
      assign [instance="steamwebhelper"] workspace number 14
      for_window [app_id="quicknote-editor-floating"] floating enable

      exec firefox
      exec thunderbird
      exec telegram-desktop
      exec element-desktop
      exec steam

      workspace 1
    '';
    config = {
      fonts = font;
      input = { "*" = { xkb_layout = "gb"; }; };
      output = { "*" = { bg = "${../data/wallpaper.png} fill"; }; };
      bars = [ ];
      window = {
        titlebar = false;
        hideEdgeBorders = "both";
      };
      workspaceAutoBackAndForth = true;
      gaps = {
        smartBorders = "on";
        smartGaps = true;
        inner = 5;
        outer = -5;
      };
      keybindings = lib.mkOptionDefault {
        "${mod}+d" = "exec ${rofi-package}/bin/rofi -show run";
        "${mod}+c" = ''
          exec ${rofi-package}/bin/rofi -show calc -modi calc -no-show-match -no-sort -hint-result "" -no-history'';

        "${mod}+grave" = "workspace back_and_forth";

        "${mod}+Shift+p" =
          "exec --no-startup-id ${pkgs.mpc-cli}/bin/mpc toggle";
        "${mod}+Shift+bracketleft" =
          "exec --no-startup-id ${pkgs.mpc-cli}/bin/mpc prev";
        "${mod}+Shift+bracketright" =
          "exec --no-startup-id ${pkgs.mpc-cli}/bin/mpc next";
        "${mod}+Shift+minus" =
          "exec --no-startup-id ${pkgs.mpc-cli}/bin/mpc volume -10";
        "${mod}+Shift+equal" =
          "exec --no-startup-id ${pkgs.mpc-cli}/bin/mpc volume +10";
        "${mod}+Shift+numbersign" = "exec --no-startup-id dmenu_mpd";
        "${mod}+Return" = ''exec ${pkgs.foot}/bin/footclient -D "$(wcwd)"'';
        "${mod}+Shift+n" = "exec quicknote";

        "Print" =
          "exec ${pkgs.slurp}/bin/slurp | ${pkgs.grim}/bin/grim -g - - | ${pkgs.wl-clipboard}/bin/wl-copy --type image/png";

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
        "${mod}+numbersign" = "exec --no-startup-id rofi_swayws";

        "${mod}+Shift+m" = "exec mpv-open-clipboard";
        "XF86Calculator" = "exec mpv-open-clipboard";
      };
    };
  };

  services.swayidle = {
    enable = true;
    timeouts = [
      {
        timeout = blank_timeout;
        command = "${pkgs.sway}/bin/swaymsg \"output * power off\"";
        resumeCommand = "${pkgs.sway}/bin/swaymsg \"output * power on\"";
      }
      {
        timeout = blank_timeout;
        command = "${pkgs.mpc-cli}/bin/mpc pause";
      }
    ];
  };
}

{
  config,
  pkgs,
  lib,
  ...
}:
let
  p = config.scheme;
in
{
  programs.waybar = {
    enable = true;
    style = ./style.css;
    systemd.enable = true;

    settings = {
      mainBar = {
        height = 25;
        position = "bottom";
        spacing = 4;

        modules-left = [
          "sway/workspaces"
          "sway/mode"
        ];
        modules-center = [ ];
        modules-right = [
          "mpd"
          "cpu"
          "memory"
          "clock"
          "tray"
        ];

        clock = {
          calendar = {
            format = {
              days = "<span color='#${p.cyan}'>{}</span>";
              today = "<span color='#${p.green}'><b>{}</b></span>";
              weekdays = "<span color='#${p.yellow}'>{}</span>";
            };
            mode = "month";
            on-scroll = 1;
          };
          actions = {
            on-scroll-up = "shift_down";
            on-scroll-down = "shift_up";
          };
          format = "{:%a %d %b %Y %H:%M}";
          format-alt = "{:%Y-%m-%d}";
          tooltip-format = "<big>{calendar}</big>";
        };
        cpu = {
          format = "";
          format-high = "<span color='#${p.red}'>{usage}% CPU</span>";
          states = {
            high = 75;
          };
          tooltip = false;
        };
        memory = {
          format = "";
          format-visible = "<span color='#${p.red}'>{percentage}/{swapPercentage}% MEM</span>";
          states = {
            visible = 75;
          };
        };
        mpd = {
          format = "<span foreground='#${p.green}'>{artist}</span> <span foreground='#${p.red}'>{title}</span> <span foreground='#${p.blue}'>{album}</span>";
          format-paused = "<span foreground='#${p.green}70'>{artist}</span> <span foreground='#${p.red}70'>{title}</span> <span foreground='#${p.blue}70'>{album}</span>";

          format-disconnected = "";
          format-stopped = "";
          interval = 5;
          tooltip = false;
          unknown-tag = "N/A";
          artist-len = 50;
          album-len = 50;
          title-len = 50;
          on-click = "${lib.getExe pkgs.mpc} toggle";
        };
        "sway/mode" = {
          format = "<span style=\"italic\">{}</span>";
        };
        tray = {
          spacing = 10;
        };
      };
    };
  };
}

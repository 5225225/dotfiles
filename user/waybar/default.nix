{ config, ... }:
let p = config.colorScheme.palette;
in {
  programs.waybar = {
    enable = true;
    style = ./style.css;
    systemd.enable = true;

    settings = {
      mainBar = {
        clock = {
          calendar = {
            format = {
              days = "<span color='#ecc6d9'><b>{}</b></span>";
              months = "<span color='#ffead3'><b>{}</b></span>";
              today = "<span
    color='#ff6699'><b><u>{}</u></b></span>";
              weekdays = "<span color='#ffcc66'><b>{}</b></span>";
              weeks = "<span color='#99ffdd'><b>W{}</b></span>";
            };
            mode = "year";
            mode-mon-col = 3;
            on-scroll = 1;
            weeks-pos = "right";
          };
          format = "{:%a %d %b %Y %H:%M}";
          format-alt =
            "{:%Y-%m-%d}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };
        cpu = {
          format = "";
          format-high = "<span color='#${p.base08}'>{usage}% CPU</span>";
          states = {
            high = 75;
          };
          tooltip = false;
        };
        height = 25;
        idle_inhibitor = {
          format = "{icon}";
          format-icons =
            { activated = ""; deactivated = ""; };
        };
        keyboard-state = {
          capslock = true;
          format =
            "{name} {icon}";
          format-icons = { locked = ""; unlocked = ""; };
          numlock = true;
        };
        memory =
          {
            format = "";
            format-visible = "<span color='#${p.base08}'>{percentage}% MEM</span>";
            states = {
              visible = 75;
            };
          };
        modules-center = [ ];
        modules-left = [ "sway/workspaces" "sway/mode" ];
        modules-right = [ "mpd" "cpu" "memory" "clock" "tray" ];
        mpd = {
          format = "<span foreground='#${p.base0B}'>{artist}</span> <span foreground='#${p.base08}'>{title}</span> <span foreground='#${p.base0D}'>{album}</span>";
          format-paused = "<span foreground='#${p.base0B}70'>{artist}</span> <span foreground='#${p.base08}70'>{title}</span> <span foreground='#${p.base0D}70'>{album}</span>";

          format-disconnected = "";
          format-stopped = "";
          interval = 5;
          tooltip-format = "MPD (connected)";
          tooltip-format-disconnected = "MPD (disconnected)";
          unknown-tag = "N/A";
          artist-len = 50;
          album-len = 50;
          title-len = 50;
        };
        position = "bottom";
        spacing = 4;
        "sway/mode" = {
          format = "<span style=\"italic\">{}</span>";
        };
        tray = { spacing = 10; };
      };
    };
  };
}

{
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
          format-high = "<span color='#ab4642'>{usage}% CPU</span>";
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
            format-visible = "<span color='#ab4642'>{percentage}% MEM</span>";
            states = {
              visible = 75;
            };
          };
        modules-center = [ ];
        modules-left = [ "sway/workspaces" "sway/mode" ];
        modules-right = [ "mpd" "cpu" "memory" "clock" "tray" ];
        mpd = {
          format = "<span
    foreground='#a1b56c'>{artist}</span> <span foreground='#ac4142'>{title}</span> <span
    foreground='#6a9fb5'>{album}</span>";
          format-disconnected = "";
          format-paused = "<span
    foreground='#4f5935'>{artist}</span> <span foreground='#542020'>{title}</span> <span
    foreground='#344e59'>{album}</span>";
          format-stopped = "";
          interval = 5;
          tooltip-format = "MPD
    (connected)";
          tooltip-format-disconnected = "MPD (disconnected)";
          unknown-tag = "N/A";
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

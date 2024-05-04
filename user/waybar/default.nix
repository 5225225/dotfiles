{
  programs.waybar = {
    enable = true;
    style = ./style.css;
    systemd.enable = true;
  };

  xdg.configFile."waybar/config".source = ./config.jsonc;
}

{ config, ...}:
let p = config.colorScheme.palette;
in {
  programs.foot = {
    enable = true;
    server.enable = true;
    settings = {
      main = {
        font = "Tamzen:size=12";
        bold-text-in-bright = "palette-based";
        pad = "4x4";
      };
      key-bindings = {
        show-urls-launch = "Control+u";
      };
      colors = {
        alpha = 0.85;
        background = "000000";
        foreground = "${p.base05}";
        regular0 = "${p.base00}";
        bright0 = "${p.base03}";

        regular1 = "${p.base08}";
        bright1 = "${p.base08}";

        regular2 = "${p.base0B}";
        bright2 = "${p.base0B}";

        regular3 = "${p.base0A}";
        bright3 = "${p.base0A}";

        regular4 = "${p.base0D}";
        bright4 = "${p.base0D}";

        regular5 = "${p.base0E}";
        bright5 = "${p.base0E}";

        regular6 = "${p.base0C}";
        bright6 = "${p.base0C}";

        regular7 = "${p.base05}";
        bright7 = "${p.base07}";
      };
    };
  };
}

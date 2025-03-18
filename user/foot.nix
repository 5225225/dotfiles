{
  pkgs,
  lib,
  config,
  ...
}:
let
  p = config.scheme;
  handleOutput = lib.getExe (
    pkgs.writeShellApplication {
      name = "pipe-command-output-handler";
      text = ''
        f=$(mktemp --tmpdir "last-command-output.XXXXXX.txt")
        cat - > "$f"
        foot nvim -n "$f"
      '';
    }
  );
in
{
  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = "Tamzen:size=12";
        bold-text-in-bright = "palette-based";
        pad = "4x4";
      };
      key-bindings = {
        show-urls-launch = "Control+u";
        pipe-command-output = ''[${handleOutput}] Control+i'';
      };
      scrollback = {
        lines = 100000;
      };
      colors = {
        alpha = 0.85;
        background = "000000";
        foreground = "${p.base07}";

        regular0 = "${p.base00}";
        bright0 = "${p.base04}";

        regular1 = "${p.red}";
        bright1 = "${p.bright-red}";

        regular2 = "${p.green}";
        bright2 = "${p.bright-green}";

        regular3 = "${p.yellow}";
        bright3 = "${p.yellow}";

        regular4 = "${p.blue}";
        bright4 = "${p.bright-blue}";

        regular5 = "${p.magenta}";
        bright5 = "${p.bright-magenta}";

        regular6 = "${p.cyan}";
        bright6 = "${p.bright-cyan}";

        regular7 = "${p.base05}";
        bright7 = "${p.base07}";
      };
    };
  };
}
